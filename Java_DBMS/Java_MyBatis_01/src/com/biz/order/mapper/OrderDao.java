package com.biz.order.mapper;

import java.util.List;

import com.biz.order.model.OrderVO;

public interface OrderDao {
	
	//Invalid bound statement (not found) : com.biz.order.mapper.OrderDao.findBySeq
	//Dao에는 Mapper가 존재하는데 Mapper에는 같은 이름(id 값)의 tag속성을 찾지 못할 경우 발생하는 오류
	
	public List<OrderVO> selectAll();
	public OrderVO findBySeq(long seq);	//long seq를 매개변수로 받아 1개의 데이터만 OrderVO에 전달
	
	public List<OrderVO> findByPcode(String pcode);
	public List<OrderVO> findByPname(String pname);
	public List<OrderVO> findByDateDistance(String start_date, String end_date);

	public int insert(OrderVO orderVO);
	public int update(OrderVO orderVO);
	public int delete(long seq);

}
