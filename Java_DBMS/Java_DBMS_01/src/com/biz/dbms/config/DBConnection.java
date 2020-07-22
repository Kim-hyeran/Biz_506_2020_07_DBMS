package com.biz.dbms.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	//정보은닉
	private static Connection dbConn=null;
	
	static {
		
		try {
			Class.forName(DBContract.DB_DRIVER);
			dbConn=DriverManager.getConnection(DBContract.DB_URL, DBContract.DB_USER, DBContract.DB_PASSWORD);
			
			System.out.println("DB Connection Success.");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	} //end static
	
	//외부에서는 get() method를 통해 정보에 접근하도록 함 : 캡슐화
	public static Connection getDBConnection() {
		return dbConn;
	}

}
