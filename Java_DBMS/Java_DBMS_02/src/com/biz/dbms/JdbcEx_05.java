package com.biz.dbms;

import java.sql.SQLException;
import java.util.List;
import java.util.Scanner;

import com.biz.dbms.config.Lines;
import com.biz.dbms.domain.OrderVO;
import com.biz.dbms.service.OrderInput;
import com.biz.dbms.service.OrderService;
import com.biz.dbms.service.OrderServiceImplV1;
import com.biz.dbms.service.OrderView;

public class JdbcEx_05 {
	
	public static void main(String[] args) {
		
		OrderService oService=new OrderServiceImplV1();
		OrderInput oInput=new OrderInput();
		OrderView oView=new OrderView();
		
		Scanner scan=new Scanner(System.in);
		
		while(true) {
			System.out.println("\t<아마전 쇼핑몰 주문서 관리 시스템 v1>");
			System.out.println(Lines.getDLine(55));
			System.out.println("1. 주문서 리스트 보기");
			System.out.println("2. 상세 주문서 보기");
			System.out.println("3. 주문서 입력");
			System.out.println("4. 주문서 수정");
			System.out.println("5. 주문서 삭제");
			System.out.println(Lines.getSLine(55));
			System.out.println("Q. 업무 종료");
			System.out.println(Lines.getDLine(55));
			System.out.print("업무 선택>> ");
			
			String strMenu=scan.nextLine();
			if(strMenu.equals("Q")) {
				break;
			}
			int intMenu=0;
			try {
				intMenu=Integer.valueOf(strMenu);
			} catch (Exception e) {
				// TODO: handle exception
				System.out.println("업무는 숫자 1부터 5 사이의 숫자로만 선택할 수 있습니다.");
				continue;
			}
			
			List<OrderVO> orderList;
			try {
				if(intMenu==1) {
					orderList = oService.selectAll();
					oView.orderList(orderList);
				} else if(intMenu==2) {
					//전체 리스트 출력 후 SEQ를 입력받고 detailView 실행
					orderList=oService.selectAll();
					oView.orderList(orderList);
					OrderVO orderVO=oInput.detailView();
				} else if(intMenu==3) {
					if(!oInput.orderInsert()) {
						break;
					}
					//입력이 완료된 후 입력이 잘 되었는지 list로 확인
					orderList=oService.selectAll();
					oView.orderList(orderList);
				} else if(intMenu==4) {
					if(!oInput.orderUpdate()) {
						break;
					}
					orderList=oService.selectAll();
					oView.orderList(orderList);
				} else if(intMenu==5) {
					//삭제를 위한 리스트 출력
					orderList=oService.selectAll();
					oView.orderList(orderList);
					if(!oInput.orderDelete()) {
						break;
					}
					//삭제 후 확인을 위한 리스트 보여주기
					orderList=oService.selectAll();
					oView.orderList(orderList);
				} else {
					System.out.println("업무는 숫자 1부터 5 사이의 숫자로만 선택할 수 있습니다.");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		System.out.println("업무가 종료되었습니다.");
	}

}
