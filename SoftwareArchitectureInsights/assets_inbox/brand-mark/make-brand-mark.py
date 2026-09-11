from PIL import Image, ImageFilter, ImageDraw, ImageFont
U='/mnt/user-data/uploads/AtchisonWebsites/SoftwareArchitectureInsights/src/'
src=Image.open(U+'images/brand/conductor-illustration-tall.png').convert('RGBA')
A=src.split()[3].crop((95,0,715,620))
PAPER=(246,243,236); BLUE=(30,95,168)
def make(size, dil, bg, fg, pad=0.06):
    m=A.filter(ImageFilter.MaxFilter(dil)) if dil>1 else A
    big=size*8; inner=int(big*(1-2*pad))
    mm=m.resize((inner,inner),Image.LANCZOS)
    im=Image.new('RGB',(big,big),bg); im.paste(Image.new('RGB',(inner,inner),fg),(int(big*pad),int(big*pad)),mm)
    return im.resize((size,size),Image.LANCZOS)
dils={16:41,32:27,48:21,180:5,192:5,512:3}
out={}
for name,bg,fg in [('paper',PAPER,BLUE),('blue',BLUE,PAPER)]:
    for s,d in dils.items():
        out[(name,s)]=make(s,d,bg,fg); out[(name,s)].save(f'fav-{name}-{s}.png')
cur={16:Image.open(U+'favicon-16x16.png').convert('RGB'),32:Image.open(U+'favicon-32x32.png').convert('RGB'),180:Image.open(U+'apple-touch-icon.png').convert('RGB').resize((180,180))}
f=ImageFont.truetype('/usr/share/fonts/truetype/google-fonts/Lora-Variable.ttf',22)
fs=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',13)
sh=Image.new('RGB',(920,740),'white'); d=ImageDraw.Draw(sh)
d.text((150,15),'16 px (tab): 1x and 4x',fill='#333',font=fs); d.text((420,15),'32 px: 1x and 3x',fill='#333',font=fs); d.text((700,15),'180 px (phone home screen)',fill='#333',font=fs)
for r,(lab,g) in enumerate([('Current',lambda s:cur[s]),('Paper',lambda s:out[('paper',s)]),('Blue',lambda s:out[('blue',s)])]):
    y=45+r*230
    d.text((20,y+80),lab,fill='#1A2330',font=f)
    i16=g(16); sh.paste(i16,(150,y+10)); sh.paste(i16.resize((64,64),Image.NEAREST),(180,y+10))
    i32=g(32); sh.paste(i32,(420,y+10)); sh.paste(i32.resize((96,96),Image.NEAREST),(465,y+10))
    sh.paste(g(180),(700,y+10))
    for k,(tb,tx) in enumerate([('#e8eaed','#202124'),('#35363a','#e8eaed')]):
        ty=y+110+k*40; d.rounded_rectangle((150,ty,560,ty+32),8,fill=tb); sh.paste(i16,(162,ty+8)); d.text((186,ty+8),'Software Architecture Insights',fill=tx,font=fs)
sh.save('/mnt/user-data/outputs/favicon-mockups.png')

# --- nav mark: transparent, brand blue, for 36px CSS display
def mark(px, dil, pad=0.02):
    m=A.filter(ImageFilter.MaxFilter(dil))
    big=px*8; inner=int(big*(1-2*pad))
    mm=m.resize((inner,inner),Image.LANCZOS)
    im=Image.new('RGBA',(big,big),BLUE+(0,)); layer=Image.new('RGBA',(inner,inner),BLUE+(255,)); layer.putalpha(mm)
    im.alpha_composite(layer,(int(big*pad),int(big*pad)))
    return im.resize((px,px),Image.LANCZOS)
nm=mark(108,13); nm.save('sai-nav-mark.png')
cursq=Image.open('../sq.png').convert('RGB')
ft=ImageFont.truetype('/usr/share/fonts/truetype/google-fonts/Lora-Variable.ttf',21)
bar=Image.new('RGB',(1000,300),'white'); d=ImageDraw.Draw(bar)
for r,(lab,ic) in enumerate([('Current',cursq.resize((36,36),Image.LANCZOS).convert('RGBA')),('New',nm.resize((36,36),Image.LANCZOS))]):
    for sc in (1,2):
        y=20+r*140; x0=20 if sc==1 else 480
        W,H=420*sc//1 if sc==1 else 480, 60*sc//1
        hb=Image.new('RGB',(420,60),PAPER); hd=ImageDraw.Draw(hb)
        hb.paste(ic,(14,12),ic); hd.text((60,17),'Software Architecture Insights',fill=(26,35,48),font=ft)
        if sc==2: hb=hb.resize((840//2*1,120//2*1),Image.NEAREST)
        bar.paste(hb.resize((420*sc//1 if sc==1 else 480, 60 if sc==1 else 69),Image.LANCZOS) if sc==2 else hb,(x0,y+20))
        d.text((x0,y),f'{lab} menu bar' + (' (zoomed)' if sc==2 else ' (actual size)'),fill='#555',font=fs)
bar.save('/mnt/user-data/outputs/nav-mark-mockup.png')
