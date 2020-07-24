package com.biz.order.config;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

/*
 * mybatis-context.xml 파일을 읽어서 설정된 값으로 SqlSessionFactory를 생성
 * DBMS에 SQL을 주고받을 때 SQL을 DBMS가 알 수 있는 데이터로 변환하고, DBMS가 데이터(Table)를 보낼 때 java가 인식할 수 있는 데이터로 변환
 * 		-> model 클래스(VO, DTO)에 데이터를 자동으로 추가해주는 기능 수행
 */

public class DBConnection {
	
	private static SqlSessionFactory sqlSessionFactory;
	private static String contextFile;
	
	// 자료 결합도가 구현된 method
	static {
		contextFile="com/biz/order/config/mybatis-context.xml";
		InputStream inputStream=null;
		
		try {
			//org.apache.ibatis.io.Resources
			//mybatis configuration 문서를 읽어 xml로 설정된 항목들을 가져와 mybatis에서 사용할 수 있는 데이터 형태로 변환하여 inputStream에 저장 요청
			inputStream=Resources.getResourceAsStream(contextFile);
			
			SqlSessionFactoryBuilder builder=new SqlSessionFactoryBuilder();
			
			/*
			 * SingleTone Pattern
			 * - sqlSessionFactory는 project가 시작될 때 만들어져 JVM이 관리하는 객체가 된다(static으로 선언된 변수이기 때문).
			 * - 만약 이 project를 어떤 경로로 2번 이상 작동을 시킨다면 작동되는 횟수만큼 sqlSessionFactory가 계속되가 생성될 것
			 * - sqlSessionFactory 객체는 수행하는 일이 많아 생성하는 것 차체만으로 JVM 입장에서는 부담이 될 수 있다.
			 * 		sqlSessionFactory를 생성하기 전, 누군가 생성하여 사용 중이라면 재생성하지 않고 만들어진 것을 활용하는 것이 좋다.
			 * 		아래 if 조건문은 아직 아무도 sqlSessionFactory를 생성하지 않았을 경우에만 생성하도록 조건을 부여하는 것
			 * - 보통 이러한 객체는 private으로 선언하고 생성에 조거는 부여해 외부에서는 getter method를 통해 접근하도록 한다.
			 */
			if(sqlSessionFactory==null) {
				//SqlSessionFactoryBuilder의 builder() method에 Resource.get...(context)로 읽어들인 inputStream 객체를 매개변수로 전달만 하면
				//	sqlSessionFactory를 생성하여 return해 준다.
				sqlSessionFactory=builder.build(inputStream);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("SqlSessionFactory 생성 중 xml 파일에 문제가 발생하였습니다.");
			e.printStackTrace();
		}
	}
	
	//외부에서 호출할 수 있도록 getter() method 작성
	public static SqlSessionFactory getSqlSessionFactory() {
		return sqlSessionFactory;
	}

}