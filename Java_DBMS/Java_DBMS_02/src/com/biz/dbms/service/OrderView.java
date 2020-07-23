package com.biz.dbms.service;

import java.util.List;

import com.biz.dbms.config.Lines;
import com.biz.dbms.domain.OrderVO;

public class OrderView {
	
	//List<OrderVO> orderList : 결합도 높음
	
	//결합도가 가장 낮은 방식의 코드(List를 매개변수로 사용)
	public void orderList(List<OrderVO> orderList) {
		System.out.println("<주문내역서>");
		System.out.println(Lines.dLine);
		System.out.println("SEQ\t주문번호\t주문일자\t고객\t상품\t수량\t가격\t합계");
		System.out.println(Lines.sLine);
		
		for (OrderVO orderVO : orderList) {
			System.out.printf("%5d\t", orderVO.getO_seq());
			System.out.print(orderVO.getO_num()+"\t\t");
			System.out.print(orderVO.getO_date()+"\t");
			System.out.print(orderVO.getO_cnum()+"\t");
			System.out.print(orderVO.getO_pcode()+"\t");
			System.out.print(orderVO.getO_qty()+"\t");
			System.out.print(orderVO.getO_price()+"\t");
			System.out.println(orderVO.getO_total());
		}
		
		System.out.println(Lines.dLine);
	} //end orderList
	
	public void orderDetailView(OrderVO orderVO) {
		System.out.println("=====================");
		System.out.printf("주문번호 : %s\n", orderVO.getO_num());
		System.out.printf("고객번호 : %s\n", orderVO.getO_cnum());
		System.out.printf("상품번호 : %s\n", orderVO.getO_pcode());
		System.out.printf("수량 : %d\n", orderVO.getO_qty());
		System.out.printf("가격 : %d\n", orderVO.getO_price());
		System.out.println("=====================");
	}

}
