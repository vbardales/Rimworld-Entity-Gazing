// Run with Node; set NODE_PATH to a directory containing playwright and sharp.
const fs=require('fs'),path=require('path');
const {chromium}=require('playwright'),sharp=require('sharp');
const root=path.resolve(__dirname,'..');
const art=__dirname;
(async()=>{
 const browser=await chromium.launch({channel:'chrome',headless:true});
 try {
 const page=await browser.newPage({viewport:{width:896,height:504},deviceScaleFactor:1});
 await page.route('http://preview.local/**',async route=>{
  const p=path.resolve(root,'.'+new URL(route.request().url()).pathname);
  if(!p.startsWith(root+path.sep)) throw Error('Path outside repository');
  await route.fulfill({body:fs.readFileSync(p),contentType:p.endsWith('.html')?'text/html':p.endsWith('.json')?'application/json':p.endsWith('.xml')?'application/xml':'image/png'});
 });
 await page.goto('http://preview.local/Art/preview-overlay.html'); await page.evaluate(()=>window.previewReady);
 const cdp=await page.context().newCDPSession(page);await cdp.send('DOM.enable');await cdp.send('CSS.enable');
 const {root:doc}=await cdp.send('DOM.getDocument');
 const report={date:new Date().toISOString(),fonts:{},boxes:{},contrast:{}};
 for(const selector of ['h1','p','.version']){
  const {nodeId}=await cdp.send('DOM.querySelector',{nodeId:doc.nodeId,selector});
  report.fonts[selector]=(await cdp.send('CSS.getPlatformFontsForNode',{nodeId})).fonts;
  report.boxes[selector]=await page.locator(selector).boundingBox();
 }
 report.version=await page.locator('.version').textContent();
 const png=await page.screenshot();
 await sharp(png).png({compressionLevel:9}).toFile(path.join(root,'Mod/About/Preview.png'));
 await sharp(png).resize({width:268}).png().toFile(path.join(art,'preview-268.png'));
 await page.addStyleTag({content:'h1,p,.version { visibility:hidden!important }'});
 const bg=await page.screenshot();await sharp(bg).png().toFile(path.join(art,'preview-background.png'));
 const {data,info}=await sharp(bg).removeAlpha().raw().toBuffer({resolveWithObject:true});
 const palette=JSON.parse(fs.readFileSync(path.join(art,'preview-palette.json'),'utf8').replace(/^\uFEFF/,''));
 function lum(rgb){const a=rgb.map(v=>{v/=255;return v<=.04045?v/12.92:((v+.055)/1.055)**2.4});return a[0]*.2126+a[1]*.7152+a[2]*.0722}
 const rgb=h=>h.slice(1).match(/../g).map(x=>parseInt(x,16));
 function contrast(a,b){const x=lum(a),y=lum(b);return (Math.max(x,y)+.05)/(Math.min(x,y)+.05)}
 for(const sel of ['h1','p']){
  const b=report.boxes[sel];let min=Infinity;
  for(let y=Math.floor(b.y);y<Math.ceil(b.y+b.height);y++)for(let x=Math.floor(b.x);x<Math.ceil(b.x+b.width);x++){
   const i=(y*info.width+x)*info.channels;
   min=Math.min(min,contrast(rgb(palette.inkPrimary),[data[i],data[i+1],data[i+2]]));
  }
  report.contrast[sel]=min;
 }
 report.contrast.badge=contrast(rgb(palette.badgeInk),rgb(palette.accent));
 report.tag='Not applicable: original public mod, no tag or title affix';
 report.bytes=fs.statSync(path.join(root,'Mod/About/Preview.png')).size;
 report.dimensions={width:896,height:504};
 fs.writeFileSync(path.join(art,'preview-qa.json'),JSON.stringify(report,null,2)+'\n');
 console.log(JSON.stringify(report,null,2));
 if(Object.values(report.contrast).some(x=>x<4.5)||report.bytes>=900*1024)throw Error('Preview QA failed');
 if(Object.values(report.fonts).flat().some(f=>!['Segoe UI','Segoe UI Semibold'].includes(f.familyName)))throw Error('Unexpected font');
 }finally{await browser.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
