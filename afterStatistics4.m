final1=zeros(5,1,2);  
for kk=1:5
s=cell2mat({STATSFINAL_DTF(1,kk:kk).DTF.measure1})
final1(kk,:,:)=s
clear s
end
final1=squeeze(final1)

final3=zeros(5,40,4);
for kk=1:5
s=cell2mat({STATSFINAL_DTF(1,kk:kk).DTF.measure3})
final3(kk,(8*kk)-8+1:kk*8,:)=s
clear s
end

final4=zeros(5, 10, 8);
for kk=1:5
s=cell2mat({STATSFINAL_DTF(1,kk:kk).DTF.measure4})
num_spikes=size(s,1);
if num_spikes==2, 
    final4(kk,(2*kk)-2+1:kk*2,:)=s
else
    final4(kk,(2*kk)-2+1:kk*num
clear s
end