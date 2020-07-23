package com.biz.dbms.service;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Scanner;

import com.biz.dbms.domain.OrderVO;

public class OrderInput {
	
	protected Scanner scan;
	protected OrderService oService;
	protected OrderView oView;
	
	public OrderInput() {
		this.scan=new Scanner(System.in);
		this.oService=new OrderServiceImplV1();
		this.oView=new OrderView();
	}
	
	public boolean orderInsert() {
		OrderVO orderVO=new OrderVO();
		
		System.out.printf("주문번호(입력종료:QUIT)>> ");
		String str_num=scan.nextLine();
		if(str_num.equals("QUIT")) {
			return false;
		}
		orderVO.setO_num(str_num);
		
		System.out.printf("고객번호(입력종료:QUIT)>> ");
		String str_cnum=scan.nextLine();
		if(str_cnum.equals("QUIT")) {
			return false;
		}
		orderVO.setO_cnum(str_cnum);
		
		System.out.printf("상품번호(입력종료:QUIT)>> ");
		String str_pcode=scan.nextLine();
		if(str_pcode.equals("QUIT")) {
			return false;
		}
		orderVO.setO_pcode(str_pcode);
		
		while(true) {
			System.out.printf("가격(입력종료:QUIT)>> ");
			String str_price=scan.nextLine();
			if(str_price.equals("QUIT")) {
				return false;
			}

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
		
		while(true) {
			System.out.printf("수량(입력종료:QUIT)>> ");
			String str_qty=scan.nextLine();
			if(str_qty.equals("QUIT")) {
				return false;
			}
				
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
		
		//JDK 1.7 이하에서는 Date() 매개변수가 필요 없다
		//JDK1.8 최신 버전에는 Date(System.current...())
		Date date=new Date(System.currentTimeMillis());
		SimpleDateFormat curDate=new SimpleDateFormat("yyyy-MM-dd");	//현재 컴퓨터 날짜
		//SimpleDateFormat curTime=new SimpleDateFormat("HH:mm:SS"); 현재 컴퓨터 시간
		orderVO.setO_date(curDate.format(date));
		
		try {
			int ret=oService.insert(orderVO);
			if(ret>0) {
				System.out.println("데이터 추가가 완료되었습니다.");
			} else {
				System.out.println("데이터 추가에 실패하였습니다.");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("SQL에 문제가 발생하였습니다.");
			e.printStackTrace();
		}
		
		return true;
	}
	
	public boolean orderUpdate() {
		try {
			oView.orderList(oService.selectAll());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.print("변경할 SEQ(수정종료 : QUIT)>> ");
		String str_seq=scan.nextLine();
		if(str_seq.equals("QUIT")) {
			System.out.println("입력이 종료되었습니다.");
			return false;
		}
		
		long longSeq=0;
		try {
			longSeq=Long.valueOf(str_seq);	
		} catch (NumberFormatException e) {
			System.out.println("SEQ는 숫자로만 입력할 수 있습니다.");
			return true;
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
			return true;
		} //코드가 여기까지 정상 진행이 된다면 입력한 SEQ에 해당하는 데이터가 orderVO에 담겨있을 것
		
		System.out.printf("변경할 주문번호 (현재:%s, 생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_num());
		String str_num=scan.nextLine();
		if(str_num.equals("QUIT")) {
			return false;
		}
		//변경할 주문번호를 입력했을 때는 입력한 주문번호를 orderVO의 o_num에 세팅한다.
		//Enter만 입력하면 통과되므로 원래 o_num에 있던 값은 유지
		if(!str_num.isEmpty()) {
			orderVO.setO_num(str_num);
		}
		
		System.out.printf("변경할 고객번호 (현재:%s, 생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_cnum());
		String str_cnum=scan.nextLine();
		if(str_cnum.equals("QUIT")) {
			return false;
		}
		if(!str_cnum.isEmpty()) {
			orderVO.setO_cnum(str_cnum);
		}
		
		System.out.printf("변경할 상품번호 (현재:%s,생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_pcode());
		String str_pcode=scan.nextLine();
		if(str_pcode.equals("QUIT")) {
			return false;
		}
		if(!str_pcode.isEmpty()) {
			orderVO.setO_pcode(str_pcode);
		}
		
		while(true) {
			System.out.printf("변경할 가격 (현재:%d,생략:Enter, 입력종료:QUIT)>> ", orderVO.getO_price());
			String str_price=scan.nextLine();
			if(str_price.equals("QUIT")) {
				return false;
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
				return false;
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
		
		return true;
		
	}

	public OrderVO detailView() {
		System.out.print("자세히 확인할 SEQ 입력>> ");
		String strSeq=scan.next();
		
		long longSeq=0;
		try {
			longSeq=Integer.valueOf(strSeq);
		} catch (Exception e) {
			System.out.println("SEQ 입력은 숫자로만 가능합니다.");
			return null;
		}
		
		try {
			OrderVO orderVO=oService.findBySeq(longSeq);
			return orderVO;
		} catch (Exception e) {
			// TODO: handle exception
		}
		return null;
	}
	
	public boolean orderDelete() {
		System.out.print("삭제할 SEQ(종료:QUIT)>> ");
		String strSeq=scan.nextLine();
		
		if(strSeq.contentEquals("QUIT")) {
			return false;
		}
		
		long longSeq=0;
		try {
			longSeq=Long.valueOf(strSeq);
		} catch (Exception e) {
			System.out.println("SEQ는 숫자로만 입력할 수 있습니다.");
			return true;
		}
		
		try {
			OrderVO orderVO=oService.findBySeq(longSeq);
			if(orderVO==null) {
				System.out.println("삭제할 데이터가 없습니다.");
				return true;
			} else {
				System.out.printf("주문번호 %s, 고객번호 %s, 상품코드 %s\n"
						+ "위의 주문을 삭제하시겠습니까?(삭제 실행:YES)>> ",
						orderVO.getO_num(), orderVO.getO_cnum(), orderVO.getO_pcode());
				String yesNo=scan.nextLine();
				if(yesNo.equals("YES")) {
					int ret=oService.delete(longSeq);
					if(ret>0) {
						System.out.println("삭제가 완료되었습니다.");
					} else {
						System.out.println("삭제에 실패하였습니다.");
					}
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}

}
