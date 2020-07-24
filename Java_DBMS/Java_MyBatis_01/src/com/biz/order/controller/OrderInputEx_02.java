package com.biz.order.controller;

import com.biz.order.service.OrderInput;

public class OrderInputEx_02 {
	
	public static void main(String[] args) {
		
		OrderInput oInput=new OrderInput();
		
		
		while(true) {
			if(!oInput.orderInsert()) {
				break;
			}
		}
		System.out.println("입력이 종료되었습니다.");
		
	}

}
