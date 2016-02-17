package tiled.main;
import tiled.core.*;
import tiled.io.TMXMapWriter;

public class createTMX {

	public static Map map;
	public static MapLayer layer;
    public String xmlPath;
    public static TMXMapWriter mapWriter;
    public static int weight = 0;
    public static int wh = 512;
    public static int [][] totalArray = new int[wh][wh];
    
    private static final int MAP_X = 3;
    private static final int MAP_Y = 3;
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("Hello World!");	
		
		for (int i = 1; i <= MAP_X; i++){
			for(int j = 1; j <= MAP_Y; j++){
				String mapName = i + "-" + j;
				createNoWaterEdgeTMX tmx = new createNoWaterEdgeTMX();
				tmx.start(mapName);
			}
		}
		createBlankTMX midTMX0 = new createBlankTMX();
		midTMX0.start("0-0");
		
//		createRightTMX rightTMX2 = new createRightTMX();
//		rightTMX2.start(totalArray, "1-2");
//		int[][] rightTMX2_Array = rightTMX2.getTotalArray();
//		
//		createRightTMX rightTMX3 = new createRightTMX();
//		rightTMX3.start(rightTMX2_Array, "1-3");
//		int[][] rightTMX3_Array = rightTMX3.getTotalArray();
//		
//		createLeftTMX leftTMX4 = new createLeftTMX();
//		leftTMX4.start(totalArray,"2-1");
//		int[][] leftTMX4_Array = leftTMX4.getTotalArray();
//		
//		createMiddleTMX midTMX5 = new createMiddleTMX();
//		midTMX5.start(leftTMX4_Array,rightTMX2_Array,"2-2");
//		int[][] midTMX5_Array = midTMX5.getTotalArray();
//		
//		createMiddleTMX midTMX6 = new createMiddleTMX();
//		midTMX5.start(midTMX5_Array,rightTMX3_Array,"2-3");
//		int[][] midTMX6_Array = midTMX6.getTotalArray();
//		
//		createLeftTMX leftTMX7 = new createLeftTMX();
//		leftTMX4.start(leftTMX4_Array,"3-1");
//		int[][] leftTMX7_Array = leftTMX7.getTotalArray();
//		
//		createMiddleTMX midTMX8 = new createMiddleTMX();
//		midTMX5.start(leftTMX7_Array,midTMX5_Array,"3-2");
//		int[][] midTMX8_Array = midTMX8.getTotalArray();
//		
//		createMiddleTMX midTMX9 = new createMiddleTMX();
//		midTMX5.start(midTMX8_Array,midTMX6_Array,"3-3");
//
//		createBlankTMX midTMX0 = new createBlankTMX();
//		midTMX0.start("0-0");
		
	}
}
