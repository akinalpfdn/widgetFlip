import { createRequire } from 'node:module';
import { fileURLToPath, pathToFileURL } from 'node:url';
import path from 'node:path';
import fs from 'node:fs/promises';
const require = createRequire(import.meta.url);
const deps = process.env.CODEX_NODE_MODULES || '/Users/akinalpfidan/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules';
const { chromium } = require(path.join(deps,'playwright'));
const sharp = require(path.join(deps,'sharp'));
const root=path.dirname(fileURLToPath(import.meta.url));
const out=path.join(root,'screenshots');
await fs.mkdir(out,{recursive:true});
const browser=await chromium.launch({channel:'chrome',headless:true,args:['--force-color-profile=srgb']});
const page=await browser.newPage({viewport:{width:2048,height:2732},deviceScaleFactor:1});
const shots=[['home','01-home-screen.png'],['sizes','02-widget-sizes.png'],['history','03-flip-history.png']];
try{
 for(const [id,name] of shots){
  await page.goto(pathToFileURL(path.join(root,'index.html')).href+'?shot='+id);
  await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode()));});
  const bad=await page.locator('.selected').evaluate(el=>[...el.querySelectorAll('.copy,.brand')].filter(e=>e.scrollWidth>e.clientWidth+1).map(e=>e.className));
  if(bad.length)throw new Error(`${id}: text overflow ${bad.join(',')}`);
  await page.screenshot({path:path.join(out,name),animations:'disabled',omitBackground:false});
  const meta=await sharp(path.join(out,name)).metadata();
  if(meta.width!==2048||meta.height!==2732||meta.hasAlpha)throw new Error(`${name}: incorrect dimensions or alpha`);
  console.log(`${name}: ${meta.width} × ${meta.height}, opaque ${meta.space}`);
 }
 await page.setViewportSize({width:1202,height:540});
 await page.goto(pathToFileURL(path.join(root,'index.html')).href);
 await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode()));});
 await page.screenshot({path:path.join(root,'preview.png'),fullPage:true,animations:'disabled'});
} finally {await browser.close();}
