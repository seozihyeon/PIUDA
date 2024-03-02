package com.example.demo.service;

import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.demo.model.RecommendBook;

@Service
public class RecommendBookService {

	public List<RecommendBook> filterByYearAndMonth(List<RecommendBook> recommendBooks, int year, int month) {
        // 결과를 담을 리스트 생성
        List<RecommendBook> filteredList;

        // 연도와 월에 해당하는 데이터만 필터링
        filteredList = recommendBooks.stream()
                .filter(recommendBook -> {
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(recommendBook.getRecommend_date());
                    int bookYear = cal.get(Calendar.YEAR);
                    int bookMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH는 0부터 시작하므로 +1을 해줍니다.
                    return bookYear == year && bookMonth == month;
                })
                .collect(Collectors.toList());

        return filteredList;
    }
}
