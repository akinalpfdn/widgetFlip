import { createRequire } from 'node:module';
import { fileURLToPath, pathToFileURL } from 'node:url';
import path from 'node:path';
import fs from 'node:fs/promises';
const require = createRequire(import.meta.url);
const deps = process.env.CODEX_NODE_MODULES || '/Users/akinalpfidan/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules';
const { chromium } = require(path.join(deps,'playwright'));
const sharp = require(path.join(deps,'sharp'));
const root=path.dirname(fileURLToPath(import.meta.url));
const copy=JSON.parse(await fs.readFile(path.join(root,'copy.json'),'utf8'));
// The English designs are the templates; their assets (real app screenshots) are shared, not copied.
const devices=[
 {id:'6.5',template:'../en-US-6.5/index.html',width:1242,height:2688},
 {id:'ipad-13',template:'../en-US-ipad-13/index.html',width:2048,height:2732},
];
const shots=[['home','01-home-screen.png'],['sizes','02-widget-sizes.png'],['history','03-flip-history.png']];
const only=process.argv.slice(2);
const langs=Object.keys(copy).filter(k=>!k.startsWith('_')&&(!only.length||only.includes(k)));

// Runs in the page: swaps English copy for the translation, then shrinks text until it clears the artwork.
function localize({c,device,shot}){
 const esc=s=>s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
 // <nobr> keeps "Home-Bildschirm" from splitting at the hyphen (not a <span>, which the template colours gold).
 const h1=s=>esc(s).replace(/(\S+-\S+)/g,'<nobr>$1</nobr>').split('\n').map(l=>l.replace(/¦/g,device==='6.5'?'<br>':' ')).join('<br>').replace(/\{(.+?)\}/g,'<span>$1</span>');
 const root=document.documentElement;root.lang=c.lang;
 const css={
  latin:'',vi:'.copy h1{line-height:1.14}.copy p{line-height:1.28}',
  cjk:'.copy h1{letter-spacing:-.02em!important;line-break:strict;word-break:keep-all}.copy p{letter-spacing:0!important;line-break:strict;word-break:keep-all}',
  arabic:'.copy,.tap,.history-panel .label{direction:rtl}.copy h1,.copy p,.tap,.caption,.history-panel .label{letter-spacing:0!important}',
 }[c.script];
 const style=document.createElement('style');style.textContent='.copy h1,.copy p{text-wrap:balance}.tap svg{flex-shrink:0}'+css;document.head.append(style);
 const s=document.getElementById(shot);const t=c[shot];
 s.querySelector('.copy h1').innerHTML=h1(t.h1);
 s.querySelector('.copy p').textContent=t.p;
 let tapWidth=0;
 if(shot==='home'){const tap=s.querySelector('.tap');tapWidth=tap.scrollWidth;[...tap.childNodes].filter(n=>n.nodeType===3).forEach(n=>n.remove());tap.append(t.tap);}
 if(shot==='sizes')for(const k of ['large','small','medium'])s.querySelector(`.caption.${k}-label`).textContent=t[k];
 if(shot==='history')s.querySelector('.history-panel .label').textContent=t.label;
 const report={};
 const copyEl=s.querySelector('.copy'),hEl=copyEl.querySelector('h1'),pEl=copyEl.querySelector('p');
 const limit=Math.min(...[...s.querySelectorAll('.phone,.tablet,.widget,.history-panel,.tap')].map(e=>e.getBoundingClientRect().top))-40;
 const h=getComputedStyle(hEl),p=getComputedStyle(pEl);
 const hf=parseFloat(h.fontSize),hl=parseFloat(h.letterSpacing)||0,pf=parseFloat(p.fontSize),pl=parseFloat(p.letterSpacing)||0;
 const over=()=>hEl.scrollWidth>hEl.clientWidth+1||pEl.scrollWidth>pEl.clientWidth+1||copyEl.getBoundingClientRect().bottom>limit;
 let k=1;
 while(over()&&k>0.55){k-=0.02;const kp=1-(1-k)*0.6;
  hEl.style.fontSize=hf*k+'px';hEl.style.letterSpacing=hl*k+'px';pEl.style.fontSize=pf*kp+'px';pEl.style.letterSpacing=pl*kp+'px';}
 report.copyScale=+k.toFixed(2);report.copyFits=!over();
 const shrink=(el,test)=>{const f=parseFloat(getComputedStyle(el).fontSize);let q=1;while(test()&&q>0.6){q-=0.03;el.style.fontSize=f*q+'px';}return +q.toFixed(2);};
 if(shot==='home'){
  // The English label deliberately overlaps the empty black part of the device screen; allow up to 1.35×
  // its width, which still clears the Search pill and dock in the screenshot. Shrink to 80% for a single
  // line, then allow two lines (never for CJK, which would split words mid-word).
  const tap=s.querySelector('.tap');tap.style.lineHeight='1.1';tap.style.maxWidth=Math.round(tapWidth*1.35)+'px';
  if(c.script==='cjk')tap.style.whiteSpace='nowrap';
  const f=parseFloat(getComputedStyle(tap).fontSize);let q=1;
  // offsetHeight ignores the -5° rotation; more than ~1.5 lines means the label wrapped.
  const wrapped=()=>tap.offsetHeight>parseFloat(getComputedStyle(tap).fontSize)*1.65;
  while((tap.scrollWidth>tap.clientWidth+1||(wrapped()&&q>0.8))&&q>0.6){q-=0.03;tap.style.fontSize=f*q+'px';}
  report.tapScale=+q.toFixed(2);report.tapLines=wrapped()?2:1;}
 if(shot==='sizes'){const w=s.getBoundingClientRect().right-50;
  if(c.dir==='rtl')for(const k of ['large','small','medium']){const cap=s.querySelector(`.caption.${k}-label`),wr=s.querySelector(`.widget.${k}`).getBoundingClientRect();
   cap.style.left=(wr.right-cap.getBoundingClientRect().width-8)+'px';}
  report.captionScale=Math.min(...[...s.querySelectorAll('.caption')].map(el=>shrink(el,()=>el.getBoundingClientRect().right>w)));}
 if(shot==='history'){const l=s.querySelector('.history-panel .label');report.labelScale=shrink(l,()=>l.scrollWidth>l.clientWidth+1);}
 return report;
}

const browser=await chromium.launch({channel:'chrome',headless:true,args:['--force-color-profile=srgb']});
const problems=[];
try{
 for(const lang of langs){
  const rows=[];
  for(const d of devices){
   const out=path.join(root,lang,d.id);await fs.mkdir(out,{recursive:true});
   const page=await browser.newPage({viewport:{width:d.width,height:d.height},deviceScaleFactor:1});
   const files=[];
   for(const [id,name] of shots){
    await page.goto(pathToFileURL(path.join(root,d.template)).href+'?shot='+id);
    await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.decode()));});
    const r=await page.evaluate(localize,{c:copy[lang],device:d.id,shot:id});
    await page.evaluate(async()=>{await document.fonts.ready;});
    const file=path.join(out,name);
    await page.screenshot({path:file,animations:'disabled',omitBackground:false});
    const meta=await sharp(file).metadata();
    if(meta.width!==d.width||meta.height!==d.height||meta.hasAlpha)throw new Error(`${lang}/${d.id}/${name}: incorrect dimensions or alpha`);
    if(!r.copyFits)problems.push(`${lang}/${d.id}/${id}: headline still overlaps artwork`);
    console.log(`${lang}/${d.id}/${name}`,JSON.stringify(r));
    files.push(file);
   }
   await page.close();
   rows.push(files);
  }
  // Contact sheet for review only: iPhone row on top, iPad row below. Not an upload image.
  const H=560,gap=24;
  const tiles=[];let y=gap,W=0;
  for(const files of rows){let x=gap;
   for(const f of files){const buf=await sharp(f).resize({height:H}).png().toBuffer();const {width}=await sharp(buf).metadata();tiles.push({input:buf,left:x,top:y});x+=width+gap;}
   W=Math.max(W,x);y+=H+gap;}
  await sharp({create:{width:W,height:y,channels:3,background:'#252525'}}).composite(tiles).png().toFile(path.join(root,lang,'preview.png'));
 }
}finally{await browser.close();}
if(problems.length){console.error(problems.join('\n'));process.exit(1);}
