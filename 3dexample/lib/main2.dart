




/*

public class Graph extends Applet{

   final static int THETA=-40,PHI=60;
   final static int XZERO=90,YZERO=360;
   final static int SIZE=160;
   final static double SINT=Math.sin(Math.toRadians(THETA));
   final static double SINP=Math.sin(Math.toRadians(PHI));
   final static double COST=Math.cos(Math.toRadians(THETA));
   final static double COSP=Math.cos(Math.toRadians(PHI));

   final int XMAX=XZERO+changeTo2D(SIZE,SIZE,SIZE).x;
   final int YMAX=YZERO+changeTo2D(SIZE,-SIZE,-SIZE).y;

   final static String[] scale
      ={"-100"," -80"," -60"," -40"," -20",
        "   0","  20","  40","  60","  80"," 100"};


   public void init(){

   }

   public void paint(Graphics g){

      Point point,point1,point2,point_old,point_new;

      int[] ymin=new int[XMAX+1];
      int[] ymax=new int[XMAX+1];


      // ---------------------- Z-軸の描画 ----------------------

      //軸を描く
      g.setColor(Color.black);
      point1=changeTo2D(-SIZE,-SIZE,-SIZE);
      point2=changeTo2D(-SIZE,-SIZE,SIZE);
      g.drawLine(point1.x,point1.y,point2.x,point2.y);

      //値に応じて着色する
      for(int z=-SIZE;z<=SIZE;z++){
         //-SIZEを-100に、SIZEを100に対応
         g.setColor(changeToColor(z*100.0/SIZE));
         point1=changeTo2D(-SIZE,-SIZE-2,z);
         point2=changeTo2D(-SIZE,-SIZE-10,z);
         g.drawLine(point1.x,point1.y,point2.x,point2.y);
      }

      //目盛を入れる
      g.setColor(Color.black);
      for(int i=0;i<11;i++){
         point1=changeTo2D(-SIZE,-SIZE,SIZE/5*i-SIZE);
         point2=changeTo2D(-SIZE,-SIZE-15,SIZE/5*i-SIZE);
         //刻みを入れる
         g.drawLine(point1.x,point1.y,point2.x,point2.y);
         //数字を入れる
         g.drawString(scale[i],point2.x-30,point2.y+5);
         //「Z-Axis」と表示
         if(i==5) g.drawString("Z-Axis",point2.x-70,point2.y+10);
      }

      // ---------------------- X-軸の描画 ----------------------

      //軸を描く
      g.setColor(Color.black);
      point1=changeTo2D(-SIZE,-SIZE,-SIZE);
      point2=changeTo2D(SIZE,-SIZE,-SIZE);
      g.drawLine(point1.x,point1.y,point2.x,point2.y);

      //目盛を入れる
      for(int i=0;i<21;i++){
         point1=changeTo2D(SIZE/10*i-SIZE,-SIZE,-SIZE);
         if(i % 2==0){                                    
            point2=changeTo2D(SIZE/10*i-SIZE,-SIZE-15,-SIZE);
            g.setColor(Color.black);
            //黒で刻みを入れる
            g.drawLine(point1.x,point1.y,point2.x,point2.y);
            //数字を入れる
            g.drawString(scale[i/2],point2.x-30,point2.y+15);
            //「X-Axis」と表示
            if(i==10) g.drawString("X-Axis",point2.x-70,point2.y+30);
         }
         else {                                       
            point2=changeTo2D(SIZE/10*i-SIZE,-SIZE-10,-SIZE);
            g.setColor(Color.gray);
            //グレイで刻みを入れる
            g.drawLine(point1.x,point1.y,point2.x,point2.y);
         } 
      }         

      // ------ Y-軸の描画(X-軸に準じるのでコメントは省略)-----

      g.setColor(Color.black);
      point1=changeTo2D(SIZE,-SIZE,-SIZE);
      point2=changeTo2D(SIZE,SIZE,-SIZE);
      g.drawLine(point1.x,point1.y,point2.x,point2.y);

      for(int i=0;i<21;i++){
         point1=changeTo2D(SIZE,SIZE/10*i-SIZE,-SIZE);
         if(i % 2==0){
            point2=changeTo2D(SIZE+15,SIZE/10*i-SIZE,-SIZE);
            g.setColor(Color.black);
            g.drawLine(point1.x,point1.y,point2.x,point2.y);
            g.drawString(scale[i/2],point2.x,point2.y+15);
            if(i==10) g.drawString("Y-Axis",point2.x+25,point2.y+30);
         }
         else{
            point2=changeTo2D(SIZE+10,SIZE/10*i-SIZE,-SIZE);
            g.setColor(Color.gray);
            g.drawLine(point1.x,point1.y,point2.x,point2.y);
         }
      }

      // ------------------- 関数値に応じて着色 -----------------

      //最大最小法による陰線処理のための準備
      for(int i=0;i<=XMAX;i++){
         ymin[i]=YMAX;
         ymax[i]=0;
      }

      //X軸、Y軸方向を細かくプロットし、着色する
      for(double x=SIZE;x>=-SIZE;x-=0.2)
         for(double y=-SIZE;y<=SIZE;y+=0.2){

            //座標上の位置を関数の変数値に変換(物理空間→論理空間))
            double xx=x*100.0/SIZE;
            double yy=y*100.0/SIZE;
            //関数の計算
            double zz=function(xx,yy);
            //関数の計算値を座標上の位置に変換(論理空間→物理空間))
            double z=SIZE/100.0*zz;

            //陰線処理を実施しながら色を変えてプロットする
            point=changeTo2D(x,y,z);
            //上に出ているので描画する(表)
            if(point.y<ymin[point.x]){
               ymin[point.x]=point.y;
               //色は関数の計算値による
               g.setColor(changeToColor(zz));
               g.drawRect(point.x,point.y,1,1);
            }
            //下に出ているので描画する(裏)
            if(point.y>ymax[point.x]){
               ymax[point.x]=point.y;
               g.setColor(Color.gray);
               g.drawRect(point.x,point.y,1,1);
            }
         }

      // ------------ Xの値をワイヤーフレームで表示 -------------

      //最大最小法による陰線処理のための準備
       for(int i=0;i<=XMAX;i++){
         ymin[i]=YMAX;
         ymax[i]=0;
      }

      point_new=new Point();
      for(int x=SIZE;x>=-SIZE;x-=2)
         for(int y=-SIZE;y<=SIZE;y++){

            //座標上の位置を関数の変数値に変換する
            double xx=x*100.0/SIZE;
            double yy=y*100.0/SIZE;
            //関数の計算            
            double zz=function(xx,yy);
            //関数の計算結果の値を座標上の位置に変換する            
            double z=SIZE/100.0*zz;

            //最初の点をpoint_oldに設定
            if(y==-SIZE) point_old=changeTo2D(x,y,z);
            //それ以外は、前の点をpoint_oldにコピー
            else         point_old=point_new;
            //新しい点を計算する
            point_new=changeTo2D(x,y,z);
            //上に出ているので描画する
            if(point_new.y<ymin[point_new.x]){
               ymin[point_new.x]=point_new.y;
               if(x % (SIZE/10) ==0){
                  //色を黒に設定
                  if(x % (SIZE/5) ==0) g.setColor(Color.black);
                  //色をグレイに設定
                  else                 g.setColor(Color.gray);
                  g.drawLine(point_old.x,point_old.y,
                     point_new.x,point_new.y);
               }
            }
            //下に出ているので描画する
            if(point_new.y>ymax[point_new.x]){
               ymax[point_new.x]=point_new.y;
               if(x % (SIZE/10) ==0){
                  //色を黒に設定
                  if(x % (SIZE/5) ==0) g.setColor(Color.black);
                  //色を白に設定
                  else                 g.setColor(Color.white);
                  g.drawLine(point_old.x,point_old.y,
                     point_new.x,point_new.y);
               }
            }
 
         }

      // ----- Yの値をワイヤーフレームで表示(コメント省略)----

      for(int i=0;i<=XMAX;i++){
         ymin[i]=YMAX;
         ymax[i]=0;
      }

      for(int y=-SIZE;y<=SIZE;y+=2)
         for(int x=SIZE;x>=-SIZE;x--){

            double xx=x*100.0/SIZE;
            double yy=y*100.0/SIZE;
            double zz=function(xx,yy);  
            double z=SIZE/100.0*zz;

            if(x==SIZE) point_old=changeTo2D(x,y,z);
            else point_old=point_new;
            point_new=changeTo2D(x,y,z);
            if(point_new.y<ymin[point_new.x]){
               ymin[point_new.x]=point_new.y;
               if(y % (SIZE/10) ==0){
                  if(y % (SIZE/5) ==0) g.setColor(Color.black);
                  else                 g.setColor(Color.gray);
                  g.drawLine(point_old.x,point_old.y,
                     point_new.x,point_new.y);
               }
            }
            if(point_new.y>ymax[point_new.x]){
               ymax[point_new.x]=point_new.y;
               if(y % (SIZE/10) ==0){
                  if(y % (SIZE/5) ==0) g.setColor(Color.black);
                  else                 g.setColor(Color.white);
                  g.drawLine(point_old.x,point_old.y,
                     point_new.x,point_new.y);
               }
            }
         }
   }


   //関数のメソッド
   private double function(double x,double y){

     return 50*Math.cos(Math.sqrt(x*x+y*y)/10.0);

   }

   //数値をカラーに変換するメソッド
   private Color changeToColor(double z){

      int d,r,g,b;

      z=z*1.6;  //補正(256段階の代わりに160段階をフルスケールにする)
      
      if(z>=0) d=(int)z % 256;
      else     d=255-(-(int)z % 256);
      int m=(int)(d/42.667);
      switch(m){
         //青→シアン
         case 0: r=0;         g=6*d;        b=255;          break;
         //シアン→緑
         case 1: r=0;         g=255;        b=255-6*(d-43); break;
         //緑→黄
         case 2: r=6*(d-86);  g=255;        b=0;            break;
         //黄→赤
         case 3: r=255;       g=255-6*(d-129); b=0;         break;
         //赤→マゼンタ
         case 4: r=255;       g=0;          b=6*(d-171);    break;
         //マゼンタ→青
         case 5: r=255-6*(d-214); g=0;      b=255;          break;
         default: r=0;        g=0;          b=0;            break;
      } 

      Color color=new Color(r,g,b);
      return color.brighter();   //明るめにする

   }

   //三次元座標をパソコン上の二次元座標に変換するメソッド
   private Point changeTo2D(double x,double y,double z){

      Point point=new Point();
      point.x=XZERO+(int)(-SINT*(x+SIZE)+COST*(y+SIZE)+0.5);
      point.y=YZERO-(int)(-COST*COSP*(x+SIZE)
         -SINT*COSP*(y+SIZE)+SINP*(z+SIZE)+0.5);
      return point;

   }
}

*/