package tiled.main;

import tiled.core.*;
import tiled.io.TMXMapWriter;
import tiled.io.xml.*;
import tiled.util.*;
import tiled.view.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.Vector;
import java.awt.*;
import java.lang.Math;

import org.json.*;
public class createNoWaterEdgeTMX {
	
	public static Map map;
	public static MapLayer layer;
    public String xmlPath;
    public static TMXMapWriter mapWriter;
    private final HashMap<String, TileSet> cachedTilesets = new HashMap<String, TileSet>();
    public int weight = 0;
    public int wh = 512;
    public int [][] totalArray = new int[wh][wh];
	public void start(String mapNumber) throws Exception{
		map = new Map(wh,wh);
		map.setOrientation(2);//2==45
		map.setTileWidth(256);
		map.setTileHeight(148);
		
		
		TileSet t = new TileSet();
		t.setTilesetImageFilename("gbn");
		t.setTilesetImageFilename("map.png");
		t.importTileBitmap("map.png", new BasicTileCutter(
                256, 200, 0, 0));
		map.addTileset(t);
		
		layer = new TileLayer();
		layer.setName("map");
		layer.setMap(map);
		Rectangle bb = new Rectangle();
		bb.width = wh;
		bb.height = wh;
		layer.getBounds(bb);
		map.addLayer(layer);
		//-------------0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
        int sizeA[] = {2,4,2,3,2,1,3,1,4,1, 4, 3, 2, 4, 3};
        int sizeB[] = {2,4,2,2,3,1,3,4,1,4, 1, 2, 3, 4, 3};
        int sizeC[] = {2,2,3,4,2,4,1,1,3,4, 2, 1, 3, 3, 4};
        int sizeD[] = {2,2,3,2,4,4,1,3,1,2, 4, 3, 1, 3, 4};
        //------------[21-25,30-33]:20%,[26-29]:60%,[34,35]:20%
        
        int faceC = 1;
        int faceD = 1;
		int random_ = 0;
		for(int i=0;i<wh; i++){
			for(int j=0;j<wh;j++){
				if(i == 0 && j == 0){
					random_ = (int)Math.round(Math.random()*19 + 1);
					totalArray[0][0] = random_;
				}
            	else{
            		if( i > 215 && i<= 295 && j > 215 && j <= 295){
        				totalArray[i][j] = 2;
            		}else{
            			if(j-1>=0 && totalArray[i][j-1] != 0 ){
                			if(totalArray[i][j-1] <= 20){
                				faceD = 1;
                			}else{
                				faceD = sizeD[totalArray[i][j-1] - 21];
                				System.out.print("totalArray_left:" + totalArray[i][j-1] + "\n");
                			}
                		}
                		
                		if(i-1>=0 && totalArray[i-1][j]!=0){
                			if(totalArray[i-1][j] <= 20){
                				faceC = 1;
                			}else{
                				faceC = sizeC[totalArray[i-1][j] - 21];
                				System.out.print("totalArray_right" + totalArray[i-1][j] + "\n");
                			}
                		}
                		
                		if( i == 214 && j > 215 && j <= 295){
                			random_ = getTile(faceD,faceC,1,0,i,j);
                		}else if(j == 214 && i > 215 && i <= 295){
                			random_ = getTile(faceD,faceC,0,1,i,j);
                		}else{
                			if(i >= 2 && j >= 2){
                				random_ = getTile(faceD,faceC,0,0,i,j);
                			}else{
                				random_ = getTile(faceD,faceC,0,0,i,j);
                			}
                			
                		}
                		
        				System.out.print("faceD:" + faceD + ",faceC:" + faceC + ",random:" + random_ + "\n");
                        totalArray[i][j] = random_;
            		}
            		
            	}
				
            
				Tile tt = new Tile();
				tt.setId(totalArray[i][j]);
				((TileLayer) layer).setTileAt(j, i, tt);
			}
			
		}
		
		mapWriter = new TMXMapWriter();
		String mapName = "map";
		mapName += mapNumber;
		mapName += ".tmx";
		mapWriter.writeMap(map, mapName);
	}
	
	public int getNoWaterTile(){
		int a = (int)Math.round(Math.random()*100);
		if( a >= 97 ){	
			return (int)Math.round((Math.random()*3)+17);
		}else if( a >= 90 && a < 97){
			return (int)Math.round((Math.random()*3)+13);
		}else {
			return (int)Math.round((Math.random()*11)+1);
		}
	}
	
	public int getTile(int faceD, int faceC, int tileFaceC, int tileFaceD,int index_i, int index_j){
		int sizeA[] = {2,4,2,3,2,1,3,1,4,1,4,3,2,4,3};
        int sizeB[] = {2,4,2,2,3,1,3,4,1,4,1,2,3,4,3};
        int sizeC[] = {2,2,3,4,2,4,1,1,3,4, 2, 1, 3, 3, 4};
        int sizeD[] = {2,2,3,2,4,4,1,3,1,2, 4, 3, 1, 3, 4};
	    int finalNum = 0;
	    Vector t = new Vector(0);
	    Vector t1 = new Vector(0);
	    
	    if( faceD == 1 && faceC == 1) {
	        if ((int)Math.round((Math.random()*19)+2) == 21) {
	        	weight++;
        		if(weight >= 13 && tileFaceC == 0 && tileFaceC == 0){
        			if (index_i == wh - 1 || index_j == wh - 1){
        				finalNum = getNoWaterTile();
        			}else{
        				weight = 0;
    		        	return 26;
        			}
	        	}else{
	        		finalNum = getNoWaterTile();
	        	}
	        }
	        else{
	        	finalNum = getNoWaterTile();
	        }
	        return finalNum;
	        
	    }
	    //处理整个地图得四个边缘，使地图边缘没有水
	    for(int i=0;i<15;i++){
	    	if(faceD == sizeA[i]){
	    		System.out.print("i==="+i);
	    		if (index_j == 0){
	    			if (sizeA[i] == 1) {
	    				t.add(i);
	    			}
	    		}else if (index_j == wh-1 && index_i == wh - 1){
	    			if (sizeC[i] == 1 && sizeD[i] == 1){
	    				t.add(i);
	    			}
	    		}else if (index_j == wh-1){
	    			if (sizeD[i] == 1){
	    				t.add(i);
	    			}
	    		}else if(index_i == wh-1){
	    			if (sizeC[i] == 1){
	    				t.add(i);
	    			}
	    		}else{
	    			t.add(i);
	    		}
	    	}
	    }

	    for(int i=0;i<t.size();i++){
	    	if(tileFaceC == 1){
	    		if( faceC == sizeB[(Integer) t.elementAt(i)] && tileFaceC == sizeC[(Integer) t.elementAt(i)]){
		    		System.out.print("\ni2==="+(Integer) t.elementAt(i));
		    		t1.add((Integer) t.elementAt(i));
		    	}
	    	}else if(tileFaceD == 1){
	    		if( faceC == sizeB[(Integer) t.elementAt(i)] && tileFaceD == sizeD[(Integer) t.elementAt(i)]){
		    		System.out.print("\ni2==="+(Integer) t.elementAt(i));
		    		t1.add((Integer) t.elementAt(i));
		    	}
	    	}else{
	    		if( faceC == sizeB[(Integer) t.elementAt(i)] ){
		    		System.out.print("\ni2==="+(Integer) t.elementAt(i));
		    		t1.add((Integer) t.elementAt(i));
		    	}
	    	}
	    	
	    }

	    return getRandomTile(t1,index_i,index_j);
	}
	
	public int getRandomTile(Vector tt,int index_i, int index_j){
		if(tt.size() != 0) {
			if(tt.size() == 1){
            	System.out.print("match map:" + tt.elementAt(0) + "\n");
            	return 20+(Integer)tt.elementAt(0)+1;
			}else{
				int n = tt.size();
				int r = (int)Math.round(Math.random()*(n-1) + 1);
				System.out.print("match map2=======================:" + (r-1) + "n===" + n +"\n");
				int total  =  (Integer)tt.elementAt(r-1) + 21;
				
				if(index_i >= 2 && index_j >= 2){
					if(totalArray[index_i - 2][index_j - 2] == totalArray[index_i - 1][index_j - 1]){
						if(total == totalArray[index_i - 1][index_j - 1]){
							total = (Integer)tt.elementAt(1-(r-1)) + 21;
						}
					}
					if(totalArray[index_i][index_j - 2] == totalArray[index_i][index_j - 1]){
						if(total == totalArray[index_i][index_j - 1]){
							total = (Integer)tt.elementAt(1-(r-1)) + 21;
						}
					}
					if(totalArray[index_i - 2][index_j] == totalArray[index_i - 1][index_j]){
						if(total == totalArray[index_i - 2][index_j]){
							total = (Integer)tt.elementAt(1-(r-1)) + 21;
						}
					}
				}
			
	            return total;
			}
        
		}else{
    		int a = (int)Math.round(Math.random()*100);
    		if( a >= 97 ){	
    			System.out.print("随机数是＝＝＝＝＝" + (int)Math.round((Math.random()*3)+17));
    			return (int)Math.round((Math.random()*3)+17);
    		}else if( a >= 90 && a < 97){
    			return (int)Math.round((Math.random()*3)+13);
    		}else {
    			return (int)Math.round((Math.random()*11)+1);
    		}
		}
        	
	}
}
