package com.example.demo.service.admin;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

import org.springframework.stereotype.Service;

import com.example.demo.mapper.BookMapper;
import com.example.demo.mapper.LoanMapper;
import com.example.demo.mapper.UserBookingMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Loan;
import com.example.demo.model.Users;

@Service
public class AdminUserBookingService {
	private final UsersMapper usersMapper;
    private final BookMapper bookMapper;
    private final LoanMapper loanMapper;
    private final UserBookingMapper userBookingMapper;

    public AdminUserBookingService(UsersMapper usersMapper, BookMapper bookMapper, LoanMapper loanMapper, UserBookingMapper userBookingMapper) {
        this.usersMapper = usersMapper;
        this.bookMapper = bookMapper;
        this.loanMapper = loanMapper;
        this.userBookingMapper = userBookingMapper;
    }
    
    public boolean applyLoan(Long user_id, String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user == null || book == null) {
        	throw new IllegalArgumentException("User or Book not found!");
        }

        Date loanDate = new Date();
        LocalDate localLoanDate = loanDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate expectedReturnDate = localLoanDate.plusDays(14);
        Boolean returnStatus = false;

        Loan loan = new Loan();
        loan.setUser(user);
        loan.setBook(book);
        loan.setLoan_date(loanDate);
        loan.setExpect_date(java.sql.Date.valueOf(expectedReturnDate));
        loan.setReturn_status(returnStatus);

        loanMapper.insertLoan(loan);
        bookMapper.updateBorrowedStatus(book_id, true);
        
        return true;
    }
    
    public void deleteBooking(Long user_id, String book_id) {
    	Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user != null && book != null) {
            int result = userBookingMapper.deleteUserBooking(user, book);
            if (result > 0) {
                bookMapper.updateBookReservedStatus(book_id, false);
                System.out.println("Book removed from user's booking list successfully");
            } else {
            	throw new IllegalArgumentException("Failed to remove book from user's booking list.");
            }
        } else {
        	throw new IllegalArgumentException("User or book not found");
        }
    }

}
