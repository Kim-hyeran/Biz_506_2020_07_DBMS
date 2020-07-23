package com.biz.dbms.config;

public class DBContract {
	
	//Oracle에 접속하기 위한 기본 정보 설정
	public final static String DB_DRIVER="oracle.jdbc.driver.OracleDriver";
	public final static String DB_URL="jdbc:oracle:thin:@localhost:1521:xe";
	public final static String DB_USER="user2";
	public final static String DB_PASSWORD="user2";
	
	//DMLdptj CRUD 중 CREATE, 데이터를 추가하는 SQL
	public final static String ORDER_INSERT=
			" INSERT INTO "
			+ORDER.TABLE + "("
			+ ORDER.COL_O_SEQ_LONG + ","
			+ ORDER.COL_O_NUM_STR + ","
			+ ORDER.COL_O_DATE_STR + ","
			+ ORDER.COL_O_CNUM_STR + ","
			+ ORDER.COL_O_PCODE_STR + ","
			+ ORDER.COL_O_QTY_INT + ","
			+ ORDER.COL_O_PRICE_INT
			+ ") VALUES ("
			+ ORDER.SEQUENCE_NEXTVAL	//o_seq 칼럼 값을 INSERT 수행 시 자동 세팅
			+ ",?,?,?,?,?,?"
			+ ")";
	
	public final static String ORDER_UPDATE=
			" UPDATE "
			+ORDER.TABLE
			+ "SET "
			+ ORDER.COL_O_NUM_STR + "= ?,"
			+ ORDER.COL_O_DATE_STR + "= ?,"
			+ ORDER.COL_O_CNUM_STR + "= ?,"
			+ ORDER.COL_O_PCODE_STR + "= ?,"
			+ ORDER.COL_O_QTY_INT + "= ?,"
			+ ORDER.COL_O_PRICE_INT + "= ?"
			+ " WHERE "
			+ ORDER.COL_O_SEQ_LONG + "= ?";
	
	public final static String ORDER_DELETE=
			" DELETE FROM "
			+ ORDER.TABLE
			+ " WHERE " + ORDER.COL_O_SEQ_LONG + "= ?";
			
	//문자열 앞뒤로 공백을 삽입하지 않으면 출력된 문장에 공백이 존재하지 않게 되어 오류가 발생한다.
	public final static String ORDER_SELECT_ALL=
			" SELECT "
			+ ORDER.COL_O_SEQ_LONG + ","
			+ ORDER.COL_O_NUM_STR + ","
			+ ORDER.COL_O_DATE_STR + ","
			+ ORDER.COL_O_CNUM_STR + ","
			+ ORDER.COL_O_PCODE_STR + ","
			+ ORDER.COL_O_PNAME_STR + ","
			+ ORDER.COL_O_QTY_INT + ","
			+ ORDER.COL_O_PRICE_INT + ","
			+ ORDER.COL_O_TOTAL_INT
			+ " FROM "+ORDER.TABLE;

	// SEQ(PK) 값으로 1개의 레코드를 검색하는 SQL
	public final static String ORDER_FIND_BY_SEQ=
			" SELECT "
			+ ORDER.COL_O_SEQ_LONG + ","
			+ ORDER.COL_O_NUM_STR + ","
			+ ORDER.COL_O_DATE_STR + ","
			+ ORDER.COL_O_CNUM_STR + ","
			+ ORDER.COL_O_PCODE_STR + ","
			+ ORDER.COL_O_PNAME_STR + ","
			+ ORDER.COL_O_QTY_INT + ","
			+ ORDER.COL_O_PRICE_INT + ","
			+ ORDER.COL_O_TOTAL_INT
			+ " FROM "+ORDER.TABLE
			+ " WHERE " + ORDER.COL_O_SEQ_LONG + "= ?";
	
	public static class ORDER {
		
		public final static String TABLE=" tbl_order ";
		public final static String SEQUENCE_NEXTVAL=" seq_order.nextval ";
		public final static String COL_O_SEQ_LONG	=	" o_seq ";		//NUMBER
		public final static String COL_O_NUM_STR	=	" o_num ";		//CHAR(6 BYTE)
		public final static String COL_O_DATE_STR	=	" o_date ";		//CHAR(10 BYTE)
		public final static String COL_O_CNUM_STR	=	" o_cnum ";		//CHAR(5 BYTE)
		public final static String COL_O_PCODE_STR	=	" o_pcode ";		//CHAR(6 BYTE)
		public final static String COL_O_PNAME_STR	=	" o_pname ";		//NVARCHAR2(125 CHAR)
		public final static String COL_O_QTY_INT	=	" o_price ";		//NUMBER
		public final static String COL_O_PRICE_INT	=	" o_qty ";		//NUMBER
		public final static String COL_O_TOTAL_INT	=	" o_total ";		//NUMBER
		
		//배열과는 달리 1부터 시작
//		public final static int POS_O_SEQ_LONG	=	1;		//NUMBER
//		public final static int POS_O_NUM_STR	=	2;		//CHAR(6 BYTE)
//		public final static int POS_O_DATE_STR	=	3;		//CHAR(10 BYTE)
//		public final static int POS_O_CNUM_STR	=	4;		//CHAR(5 BYTE)
//		public final static int POS_O_PCODE_STR	=	5;		//CHAR(6 BYTE)
//		public final static int POS_O_PNAME_STR	=	6;		//NVARCHAR2(125 CHAR)
//		public final static int POS_O_QTY_INT	=	7;		//NUMBER
//		public final static int POS_O_PRICE_INT	=	8;		//NUMBER
//		public final static int POS_O_TOTAL_INT	=	9;		//NUMBER
		
	}

}
