package com.biz.dbms.service;

import java.sql.SQLException;
import java.util.List;

import com.biz.dbms.domain.OrderVO;

public interface OrderService {
	
	//디자인 패턴
	//java를 이용한 DB CRUD 실행 시 공식처럼 사용되는 method
	
	//java에서 DBMS와 관련된 App을 제작할 때, 최소한으로 구현해야 할 method
	public int insert(OrderVO orderVO) throws SQLException;	//OrderVO에 값을 담아서 전달 받아 insert 수행
	//명령이 정상 수행 되면 항상 0보다 큰 값을 return하기 때문에 int type

	public List<OrderVO> selectAll() throws SQLException;	//조건에 관계 없이 모든 데이터를 추출하여 return
	public OrderVO findBySeq(long seq) throws SQLException;	//findById(), PK칼럼을 기준으로 데이터 SELECT

	public int update(OrderVO orderVO) throws SQLException;
	public int delete(long seq) throws SQLException;	//PK 변수의 type과 변수명을 매개변수 설정

}