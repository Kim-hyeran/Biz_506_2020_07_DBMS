package com.biz.dbms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.biz.dbms.config.DBContract;
import com.biz.dbms.domain.OrderVO;

public class JdbcEx_01 {
	
	public static void main(String[] args) {
		
		List<OrderVO> orderList=new ArrayList<OrderVO>();
		
		try {
			/* 
			 * Class.forName();
			 * - Java에서 JDBC를 통하여 Oracle Driver 클래스와 연결하고 Java 코드에서 보내는 SQL Query를 Oracle DBMS에게 전달 시
			 * 	JDBC에서 연결할 Oracle 연결 도우미 미들웨어(Oracle Driver.class)를 사용 가능한 상태로 만들어주는 Java의 한 기능
			 * 
			 * Oracle Drivaer.class를 사용할 준비
			 * - 보통은 '클래스 객체=new 클래스();'로 선언하지만 Oracle Driver.class는 태생이 Java 전용 클래스와 달라서
			 * 	사용을 위해 초기화하는 방법이 일반 클래스와 다르다.
			 * - Class.forName() method의 도움을 받아 사용 준비를 수행하는 것
			 */
			Class.forName(DBContract.DB_DRIVER);
			 
			//Oracle에 연결하기
			//1. Connection 설치
			Connection dbConn=null;
			
			//2. Connection에게 Oracle 접속 지시
			//3. 접속이 완료되면 접속 관련 정보를 dbConn 객체에 저장 
			dbConn=DriverManager.getConnection(DBContract.DB_URL, DBContract.DB_USER, DBContract.DB_PASSWORD);
			System.out.println("DB Connection Success.");
			
			//4. DB에게 SQL 보내기
			PreparedStatement pSt=null;
			String strSql=DBContract.ORDER_SELECT;
			
			//DB에게 SQL을 보내고, 그 결과를 pSt(PreparedStatement)에 받기
			//Oracle Driver를 통해서 SQL을 보낼 수 있도록 자신만의 방식으로 변경을 하고, 그 정보를 pSt에 담아 놓기
			pSt=dbConn.prepareStatement(strSql);
			
			//pSt에 담은 정보를 사용하여 SQL 명령문을 실행하도록 DB에게 전달, 결과를 ResultSet에 받기
			ResultSet result=pSt.executeQuery();
			
			//ResultSet에는 select문을 실행한 결과인 Table이 담겨있게 된다.
			/*
			 * DB Cursor
			 * - Table이 담겨있는 유사 List 자료형
			 * - 값을 추출할 때 처음부터 순서대로, 전진하는 방향으로만 추출할 수 있다.
			 * 
			 * ResultSet의 next() method를 호출하면 SELECT 결과물이 없을 경우 false를 return하고,
			 * 		결과물(Table Record)이 존재할 경우 Record로부터 데이터를 칼럼별로 추출할 수 있는 대기 상태가 된다.
			 */
			while(result.next()) {
				OrderVO orderVO=new OrderVO();
				
				String o_num=result.getNString(DBContract.ORDER.POS_O_NUM_STR); //위치값
				o_num=result.getNString(DBContract.ORDER.POS_O_NUM_STR); //칼럼명
				orderVO.setO_num(o_num);
				
				String o_cnum=result.getNString(DBContract.ORDER.POS_O_CNUM_STR);
				orderVO.setO_cnum(o_cnum);
				
				String o_pcode=result.getNString(DBContract.ORDER.POS_O_PCODE_STR);
				orderVO.setO_pcode(o_pcode);
				
				int o_price=result.getInt(DBContract.ORDER.POS_O_PRICE_INT);
				orderVO.setO_price(o_price);
				
				orderList.add(orderVO);
				
				System.out.println(result.getString(1));
			}
			result.close();
			dbConn.close();
			
			System.out.println("\t\t<주문내역>");
			System.out.println("==========================================");
			System.out.println("주문번호\t고객번호\t상품번호");
			System.out.println("------------------------------------------");
			for (OrderVO orderVO : orderList) {
				System.out.print(orderVO.getO_num()+"\t\t");
				System.out.print(orderVO.getO_cnum()+"\t\t");
				System.out.println(orderVO.getO_pcode());
			}
			
			} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			System.out.println("프로젝트에 Oracle Driver가 설치되지 않았습니다.");
		} catch (SQLException e) {
			//Oracle에서 보내는 예외(오류)의 종류는 다양하지만, eclipse에서는 전부 SQL 예외로 처리하기 때문에
			//	오류 내용을 알려주는 e.printStackTrace(); method를 사용하는 것이 좋다.
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Oracle에 접속하는 과정에서 문제가 발생하였습니다.");
		}
		
	}

}
