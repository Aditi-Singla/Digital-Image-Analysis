clc; clear all; close all;

img=imread('1.png');
[m,n,colormap]=size(img);

%%%%% Scale-up using replication %%%%%

%If RGB Image is given at Input 
if colormap==3
    x=img(:,:,1);
    y=img(:,:,2);
    z=img(:,:,3);
end

k=1; l=1;
%Replication Factor
f=2;

for i=1:m %Row
    for counter=1:f %Replication
        for j=1:n %Column
            for counter=1:f %Replication
                if colormap==3 %RGB
                    c1(k,l)= x(i,j);
                    c2(k,l)= y(i,j);
                    c3(k,l)= z(i,j);
                else %Grayscale
                    out(k,l)=img(i,j);
                end
                l=l+1;
            end
        end
        l=1;
        k=k+1;
    end
end

if colormap==3 %If Image is RGB
    out(:,:,1)=c1;
    out(:,:,2)=c2;
    out(:,:,3)=c3;
end

figure
imshow(img), title('Original')
figure, imshow(out), title('Scaled up using replication')

%%%%% Scale-down using replication %%%%%

%Replication Factor
f=2; % Actually 1/f

s=size(img);
s1=s/f;
k=1;
l=1;
for i=1:s1
    for j=1:s1
        out1(i,j)=img(k,l);
        l=l+f;
    end
    l=1;
    k=k+f;
end
figure,imshow(out1)
title('Scaled down using replication');

