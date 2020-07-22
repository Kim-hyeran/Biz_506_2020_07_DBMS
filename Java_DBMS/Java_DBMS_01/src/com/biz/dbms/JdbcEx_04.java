package com.biz.dbms;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;

import com.biz.dbms.config.DBConnection;
import com.biz.dbms.config.DBContract;

public class JdbcEx_04 {
	
	public static void main(String[] args) {
		
		Connection dbConn=DBConnection.getDBConnection();
		String delete_sql=DBContract.ORDER_DELETE;
		Scanner scan=new Scanner(System.in);
		
		System.out.print("삭제할 SEQ>> ");
		String str_seq=scan.nextLine();
		
		long long_seq=Long.valueOf(str_seq);
		
		PreparedStatement pSt;
		try {
			pSt = dbConn.prepareStatement(delete_sql);
			pSt.setLong(1, long_seq);
			
			int ret=pSt.executeUpdate();
			if(ret>0) {
				System.out.println("삭제가 완료되었습니다.");
			} else {
				System.out.println("삭제를 실패하였습니다.");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

}
