package com.biz.dbms.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

//Lombok 사용 시 기본 5가지
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class OrderVO {
	
	//DB와 연동하는 프로젝트에서는 VO클래스의 필드변수를 table 칼럼 이름과 동일하게 작성하고 snake_case로 작성
	private long o_seq;		// number
	private String o_num;		// char(6 byte)
	private String o_date;		// char(10 byte)
	private String o_cnum;		// char(5 byte)
	private String o_pcode;	// char(6 byte)
	private String o_pname;	// nvarchar2(125 char)
	private int o_price;	// number
	private int o_qty;		// number
	private int o_total;	// number
	
}