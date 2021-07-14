function glcmig()
  f1=figure('units','pixels','position', [200 200 1000 800]);
  ax1=axes('units','normalized','position',[0.05 0.5 0.3 0.3]);
  ax2=axes('units','normalized','position',[0.45 0.5 0.3 0.3]);
  
  txt1=uicontrol('units','normalized','style','text','string','distance :','position',[0.8 0.7 0.1 0.05]);
  txt2=uicontrol('units','normalized','style','text','string','angle :','position',[0.8 0.65 0.1 0.05]);
  txt3=uicontrol('units','normalized','style','text','string','levels :','position',[0.8 0.6 0.1 0.05]);
  
  edit1=uicontrol('units','normalized','style','edit','position',[0.9 0.7 0.05 0.05]);
  edit2=uicontrol('units','normalized','style','edit','position',[0.9 0.65 0.05 0.05]);
  edit3=uicontrol('units','normalized','style','edit','position',[0.9 0.6 0.05 0.05]);
  
  push1=uicontrol('units','normalized','style','pushbutton','string','buka file','position',[0.1 0.85 0.15 0.1],'callback',{@bukafile ax1});
  push2=uicontrol('units','normalized','style','pushbutton','string','convert','position',[0.45 0.85 0.15 0.1],'callback', {@convert,ax2,edit1,edit2,edit3 });
  
  
  contrast_text=uicontrol('units','normalized','style','text','string','contrast :','position',[0.2 0.2 0.1 0.05]);
  contrast_val=uicontrol('units','normalized','style','edit','position',[0.2 0.15 0.1 0.05],'enable','off');
  
  diss_text=uicontrol('units','normalized','style','text','string','dissimilarity :','position',[0.4 0.2 0.12 0.05]);
  diss_val=uicontrol('units','normalized','style','edit','position',[0.4 0.15 0.12 0.05],'enable','off');
  
  homogenity_text=uicontrol('units','normalized','style','text','string','homogenity :','position',[0.6 0.2 0.12 0.05]);
  homogenity_val=uicontrol('units','normalized','style','edit','position',[0.6 0.15 0.12 0.05],'enable','off');
  
  push3=uicontrol('units','normalized','style','pushbutton','string','find values','position',[0.4 0.35 0.15 0.05],'callback', {@process, contrast_val, diss_val,homogenity_val});
  
endfunction


function bukafile(hObject,eventdata,ax1)
  [namafile pathfile] = uigetfile('*.jpg','browse jpg file')
  img1=imread([pathfile namafile]);
  axes(ax1);
  imshow(img1);
  save img1.mat img1
endfunction

function convert(hObject,eventdata,ax1,edit1,edit2,edit3 )
  warning('off','all');
  pkg load image
  load img1.mat;
  grey=(rgb2gray(img1));
  axes(ax1);
  imshow(grey);
  save grey.mat grey
  dist=str2num(get(edit1,'string'));
  agl=str2num(get(edit2,'string'));
  lvl=str2num(get(edit3,'string'));
  
  glcm=graycomatrix(grey,lvl,dist,agl);
  save glcm.mat glcm
  glcm
endfunction
  
  
function process(hObject,eventdata,contrast_val,diss_val,homogenity_val,asm_val,energy_val)
  load glcm.mat;
  contrast=0;
  dissimilarity=0;
  homogenity=0;
  ukuran=size(glcm)
  
  for i=1:ukuran(1)
    for j=1:ukuran(2)
      contrast=contrast+(glcm(i,j,1)*(i-j)*(i-j)); 
    endfor
  endfor
  contrast=contrast/100000
  set(contrast_val,'string',num2str(contrast));
  for i=1:ukuran(1)
    for j=1:ukuran(2)
      dissimilarity=dissimilarity+(glcm(i,j,1)*abs(i-j)); 
    endfor
  endfor
  dissimilarity=dissimilarity/10000
  set(diss_val,'string',num2str(dissimilarity));
  for i=1:ukuran(1)
    for j=1:ukuran(2)
      homogenity=homogenity+(glcm(i,j,1)/1+((i-j)*(i-j))); 
    endfor
  endfor
  homogenity=homogenity/10000
  set(homogenity_val,'string',num2str(homogenity));
  endfunction