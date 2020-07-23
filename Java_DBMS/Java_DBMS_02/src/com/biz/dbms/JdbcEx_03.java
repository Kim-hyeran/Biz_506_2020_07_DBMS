package com.biz.dbms;

import java.sql.SQLException;
import java.util.Scanner;

import com.biz.dbms.domain.OrderVO;
import com.biz.dbms.service.OrderService;
import com.biz.dbms.service.OrderServiceImplV1;
import com.biz.dbms.service.OrderView;

public class JdbcEx_03 {
	
	public static void main(String[] args) {
		
		/*
		 * UPDATE 구현
		 * 1. 전체(검색 조건에 맞는) 데이터 리스트를 보여주기
		 * 2. 내용을 변경할 데이터의 seq 값을 키보드로부터 입력 받기
		 * 3. 데이터를 1개 select
		 * 4. 각 칼럼의 데이터 보여주기
		 * 5. 변경할 내용 입력 받기
		 * 6. 완료되면 UPDATE method를 호출하여 변경 수행
		 */
		
		Scanner scan=new Scanner(System.in);
		OrderService oService=new OrderServiceImplV1();
		OrderView oView=new OrderView();
		
		try {
			oView.orderList(oService.selectAll());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.print("수정할 SEQ(수정종료 : QUIT)>> ");
		String str_seq=scan.nextLine();
		if(str_seq.equals("QUIT")) {
			System.out.println("입력이 종료되었습니다.");
			return;
		}
		
		long longSeq=0;
		try {
			longSeq=Long.valueOf(str_seq);	
		} catch (NumberFormatException e) {
			System.out.println("SEQ는 숫자로만 입력할 수 있습니다.");
			return;
		}
		
		OrderVO orderVO=null;
		try {
			orderVO = oService.findBySeq(longSeq);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if(orderVO==null) {
			System.out.println("SEQ에 해당하는 데이터가 존재하지 않습니다.");
			return;
		} //코드가 여기까지 정상 진행이 된다면 입력한 SEQ에 해당하는 데이터가 orderVO에 담겨있을 것
		
		System.out.printf("변경할 주문번호 (현재:%s, 생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_num());
		String str_num=scan.nextLine();
		if(str_num.equals("QUIT")) {
			return;
		}
		//변경할 주문번호를 입력했을 때는 입력한 주문번호를 orderVO의 o_num에 세팅한다.
		//Enter만 입력하면 통과되므로 원래 o_num에 있던 값은 유지
		if(!str_num.isEmpty()) {
			orderVO.setO_num(str_num);
		}
		orderVO.setO_num(str_num);
		
		System.out.printf("변경할 고객번호 (현재:%s,생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_cnum());
		String str_cnum=scan.nextLine();
		if(str_cnum.equals("QUIT")) {
			return;
		}
		if(!str_cnum.isEmpty()) {
			orderVO.setO_cnum(str_cnum);
		}
		orderVO.setO_cnum(str_cnum);
		
		System.out.printf("변경할 상품번호 (현재:%s,생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_pcode());
		String str_pcode=scan.nextLine();
		if(str_pcode.equals("QUIT")) {
			return;
		}
		if(!str_pcode.isEmpty()) {
			orderVO.setO_pcode(str_pcode);
		}
		orderVO.setO_pcode(str_pcode);
		
		while(true) {
			System.out.printf("변경할 가격 (현재:%d,생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_price());
			String str_price=scan.nextLine();
			if(str_price.equals("QUIT")) {
				return;
			}
			if(!str_price.isEmpty()) {
				orderVO.setO_price(Integer.valueOf(str_price));
				
				int int_price=0;
				try {
					int_price=Integer.valueOf(str_price);	
				} catch (Exception e) {
					System.out.println("가격은 숫자로만 입력할 수 있습니다.");
					continue;
				}
				orderVO.setO_price(int_price);
				break;
			}
			break;
		}
		
		while(true) {
			System.out.printf("변경할 수량 (현재:%d, 생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_qty());
			String str_qty=scan.nextLine();
			if(str_qty.equals("QUIT")) {
				return;
			}
			if(!str_qty.isEmpty()) {
				orderVO.setO_qty(Integer.valueOf(str_qty));
				
				int int_qty=0;
				try {
					int_qty=Integer.valueOf(str_qty);	
				} catch (Exception e) {
					System.out.println("수량은 숫자로만 입력할 수 있습니다.");
					continue;
				}
				orderVO.setO_qty(int_qty);
				break;
			}
			break;
		}
		
		try {
			int ret=oService.update(orderVO);
			if(ret>0) {
				System.out.println("데이터 변경이 완료되었습니다.");
				
				orderVO=oService.findBySeq(orderVO.getO_seq());
				System.out.println("===========================");
				System.out.printf("주문번호 : %s\n", orderVO.getO_num());
				System.out.printf("고객번호 : %s\n", orderVO.getO_cnum());
				System.out.printf("상품번호 : %s\n", orderVO.getO_pcode());
				System.out.printf("수량 : %d\n", orderVO.getO_qty());
				System.out.printf("가격 : %d\n", orderVO.getO_price());
				System.out.println("===========================");
			} else {
				System.out.println("데이터 변경에 실패하였습니다.");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("SQL에 문제가 발생하였습니다.");
			e.printStackTrace();
		}
		
	}

}