package com.biz.dbms;

import java.sql.SQLException;

import com.biz.dbms.domain.OrderVO;
import com.biz.dbms.service.OrderService;
import com.biz.dbms.service.OrderServiceImplV1;

public class JdbcEx_01 {
	
	public static void main(String[] args) {

		OrderService orderService=new OrderServiceImplV1();
		
		OrderVO orderVO=new OrderVO();
		
		orderVO.setO_num("O00055");
		orderVO.setO_date("2020-07-23");
		orderVO.setO_cnum("C0012");
		orderVO.setO_pcode("P0001");
		orderVO.setO_qty(10);
		orderVO.setO_price(3000);
		
		int ret=0;
		try {
			ret=orderService.insert(orderVO);
			if(ret>0) {
				System.out.println("데이터 추가가 정상적으로 수행되었습니다.");
			} else {
				//SQL에는 아무런 문제가 없는데 insert가 수행되고도 데이터가 추가되지 않았을 때
				System.out.println("데이터 추가에 실패하였습니다.");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//Oracle DBMS에서 오류를 보내왔을 때
			System.out.println("SQL 전달 과정에서 오류가 발생하였습니다.");
			e.printStackTrace();
		}
		
	}

}
