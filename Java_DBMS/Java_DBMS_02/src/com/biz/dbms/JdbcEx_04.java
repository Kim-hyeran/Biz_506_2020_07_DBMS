package com.biz.dbms;

import java.sql.SQLException;
import java.util.List;

import com.biz.dbms.domain.OrderVO;
import com.biz.dbms.service.OrderInput;
import com.biz.dbms.service.OrderService;
import com.biz.dbms.service.OrderServiceImplV1;
import com.biz.dbms.service.OrderView;

public class JdbcEx_04 {
	
	public static void main(String[] args) {
		
		OrderService oService=new OrderServiceImplV1();
		OrderView oView=new OrderView();
		OrderInput oInput=new OrderInput();
		
		while(true) {
				//List 가져오기
				//List<OrderVO> orderList=oService.selectAll();
				//List 보여주기
				//oView.orderList(orderList);
				//수정사항을 입력 받고 데이터 UPDATE
				if(!oInput.orderUpdate()) {
					break;
			}
		}
		System.out.println("업무가 종료되었습니다.");
		
	}

}
