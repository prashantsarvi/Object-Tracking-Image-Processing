import java.awt.Robot;
import java.awt.event.*
mouse = Robot;


vid=videoinput('winvideo',1,'YUY2_640x480');
%vid=videoinput('winvideo',1,'YUY2_352x288');
%vid=videoinput('winvideo',1,'YUY2_640*288');
set(vid,'ReturnedColorSpace','rgb');
preview(vid);
pause(2);

while 1
    im1=getsnapshot(vid);
    % Now to track red objects in real time
    % we have to subtract the red component
    % from the grayscale image to extract the red components in the image.
    %extract red component  
    im2= imsubtract(im1(:,:,1), rgb2gray(im1));
    %extract blue component
    in2= imsubtract(im1(:,:,3), rgb2gray(im1));
    %Use a median filter to filter out noise
    im3 = medfilt2(im2, [3 3]);
    in3 = medfilt2(in2, [3 3]);
    % Convert the resultisng grayscale image into a binary image.
    im3 = im2bw(im3,0.27);
    in3 = im2bw(in3,0.32);

    imshow(im3);
    pause(0.05);
    [B,L,N]= bwboundaries(im3,'noholes');
    a = regionprops(L,'centroid');
   
    [P Q R]=bwboundaries(in3,'noholes');
    b=regionprops(Q,'centroid');
   
    if N >= 1 && R==0
         
            %(a(2).Centroid(1,1)) - (a(1).Centroid(1,1));
            %movement of cursor
            mouse.mouseMove(1600-(a(1).Centroid(1,1)*(5/2)),(a(1).Centroid(1,2)*(5/2)-180));


    end   
   
if R>=1 && N>=1
        if (a(1).Centroid(1,1)-b(1).Centroid(1,1)>70)
        %if the difference is positive then right click
        mouse.mousePress(InputEvent.BUTTON3_MASK);
        mouse.mouseRelease(InputEvent.BUTTON3_MASK);
       
        else if(a(1).Centroid(1,1)-b(1).Centroid(1,1)<-70)
        %if the difference is negative then left click
        mouse.mousePress(InputEvent.BUTTON1_MASK);
        mouse.mouseRelease(InputEvent.BUTTON1_MASK);
             end
        end
end
end