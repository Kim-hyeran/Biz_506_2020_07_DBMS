package com.biz.order.service;

import java.sql.SQLException;
import java.util.Scanner;

import com.biz.order.model.OrderVO;

public class OrderInput {
	
	private OrderService oService;
	
	Scanner scan;
	
	public OrderInput() {
		oService=new OrderServiceImplV1();
		scan=new Scanner(System.in);
	}
	
	public boolean orderInsert() {
		OrderVO orderVO=new OrderVO();
		//orderVO : 새로 생성되어 아무런 값도 없는 상태
		
		boolean ret=this.orderInput(orderVO);
		//orderVO : 입력한 주문서 정보가 담긴 상태
		
		if(ret) {
			if(oService.insert(orderVO)>0) {
				System.out.println("주문서 추가를 성공하였습니다.");
			} else {
				System.out.println("주문서 등록에 실패하였습니다.");
			}
		}
		
		return ret;
	}
	
	public boolean orderUpdate() {
		System.out.println("==============================");
		System.out.println("++++++ 주문서 수정 요령 ++++++");
		System.out.println("Prompt에 나타난 값을 확인하고");
		System.out.println("새로운 값을 입력합니다.");
		System.out.println("값을 유지하고 싶을 때는 Enter");
		System.out.println("==============================");
		
		System.out.print("수정할 SEQ 입력(수정종료:QUIT)>> ");
		String strSeq=scan.nextLine();
		if(strSeq.equals("QUIT")) {
			return false;
		}
		
		long longSeq=0;
		try {
			longSeq=Long.valueOf(strSeq);
		} catch (Exception e) {
			System.out.println("SEQ는 숫자로만 입력할 수 있습니다.");
			return false;
		}
		
		OrderVO orderVO=null;
		orderVO=oService.findBySeq(longSeq);
		if(orderVO==null) {
			System.out.println("SEQ 값을 데이터에서 찾을 수 없습니다.");
			return false;
		}
		//orderVO : DB에서 가져온 1개의 주문서가 담겨 있다.

		boolean ret=this.orderInput(orderVO);
		//orderVO : orderInput에서 변경한 주문서가 담겨 있다.
		
		if(ret) {
			if(oService.update(orderVO)>0) {
				System.out.println("주문서 수정이 완료되었습니다.");
			} else {
				System.out.println("주문서 수정에 실패하였습니다.");
			}
		}
		
		return ret;
	}
	
	public boolean orderInput(OrderVO orderVO) {
		/*
		 * orderUpdate() method에서 orderInput()을 호출했으면 orderVO의 각 필드변수들은 값을 가지고 있을 것
		 * orderInsert() method에서 호출했으면 orderVO의 각 필드변수 값은 초기값 ""(String)이거나 0(int, long)이다.
		 */
		
		System.out.printf("주문번호(%s, 입력종료:QUIT)>> ",  orderVO.getO_num()==null ? "NEW" : orderVO.getO_num());
		String strNum=scan.nextLine();
		if(strNum.equals("QUIT")) {
			return false;
		}
		
		/*
		 * 만약 insert 상태일 경우
		 * 사용자가 주문번호를 입력하지 않으면 setO_num() method를 통과하고, 아래쪽 isEmpty()의 유효성 검사를 통과하지 못함
		 * 
		 * update 상태일 경우
		 * 입력받은 strNum는 isEmpty일 것이고, 당연히 setO_num() method는 통과
		 * 그러나 이미 DB에서 읽어온 값이 담겨 있으므로 아래쪽 orderVO.getO_num().isEmpty는 통과된다.
		 */
		
		if(!strNum.isEmpty()) {
			orderVO.setO_num(strNum);
		}
		if(orderVO.getO_num().isEmpty()) {
			System.out.println("주문번호는 반드시 입력해야 합니다.");
			return true;
		}
		
		while(true) {
			System.out.printf("고객번호(%s, 입력종료:QUIT)>> ", orderVO.getO_cnum()==null ? "NEW" : orderVO.getO_cnum());
			String strCnum=scan.nextLine();
			if(strCnum.equals("QUIT")) {
				return false;
			}
			if(!strCnum.isEmpty()) {
				orderVO.setO_cnum(strCnum);
			}
			if(orderVO.getO_cnum().isEmpty()) {
				System.out.println("고객번호는 반드시 입력해야 합니다.");
				continue;
			}
			break;
		}
		
		while(true) {
			System.out.printf("상품번호(%s, 입력종료:QUIT)>> ", orderVO.getO_pcode()==null ? "NEW" : orderVO.getO_pcode());
			String strPcode=scan.nextLine();
			if(strPcode.equals("QUIT")) {
				return false;
			}
			if(!strPcode.isEmpty()) {
				orderVO.setO_pcode(strPcode);
			}
			if(orderVO.getO_pcode().isEmpty()) {
				System.out.println("상품번호는 반드시 입력해야 합니다.");
				continue;
			}
			break;
		}
		
		while(true) {
			System.out.printf("상품가격(%d, 입력종료:QUIT)>> ", orderVO.getO_price());
			String strPrice=scan.nextLine();
			if(strPrice.equals("QUIT")) {
				return false;
			}
			int intPrice=0;
			try {
				intPrice=Integer.valueOf(strPrice);
			} catch (Exception e) {
				System.out.println("상품 가격은 숫자로만 입력할 수 있습니다.");
			}
			if(intPrice>0) {
				orderVO.setO_price(intPrice);
			}
			if(orderVO.getO_price()<1) {
				System.out.println("상품가격은 0 이하가 될 수 없습니다.");
				continue;
			}
			break;
		}
		
		while(true) {
			System.out.printf("상품수량(%d 입력종료:QUIT)>> ", orderVO.getO_qty());
			String strQty=scan.nextLine();
			if(strQty.equals("QUIT")) {
				return false;
			}
			int intQty=0;
			try {
				intQty=Integer.valueOf(strQty);
			} catch (Exception e) {
				System.out.println("상품 수량은 숫자로만 입력할 수 있습니다.");
			}
			if(intQty>0) {
				orderVO.setO_qty(intQty);
			}
			if(orderVO.getO_price()<1) {
				System.out.println("상품수량은 0 이하가 될 수 없습니다.");
				continue;
			}
			break;
		}
		
		return true;
	}

}
