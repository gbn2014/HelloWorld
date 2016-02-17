package tiled.main;

import tiled.core.*;
import tiled.io.TMXMapWriter;
import tiled.util.*;

import java.awt.*;
public class createBlankTMX {

	public static Map map;
	public static MapLayer layer;
    public String xmlPath;
    public static TMXMapWriter mapWriter;
    public static int weight = 0;
    public static int wh = 512;
    public static int [][] totalArray = new int[wh][wh];
    public void start(String mapNumber) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("Hello World!");	
		
		
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

		for(int i=0;i<wh; i++){
			for(int j=0;j<wh;j++){
				totalArray[i][j] = getNoWaterTile();//21;
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
}
