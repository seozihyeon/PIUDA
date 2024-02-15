window.onload = function() {
    fetchLoanData();
    fetchUserData();
    fetchBookData();
    
    // select2 적용
   $('#userIdSelect').select2({ width: '40%' });
   $('#bookIdSelect').select2({ width: '40%' });
};
function fetchLoanData() {
    fetch('/admin/loan/all')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            displayLoans(data);
        })
        .catch(error => {
            console.error('Error fetching loan data:', error);
        });
}

function fetchLoanDataFiltered() {
    fetch('/admin/loan/all')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            const filteredData = data.filter(loan => !loan.return_status); // return_status가 false인 항목만 필터링
            displayLoans(filteredData);
        })
        .catch(error => {
            console.error('Error fetching loan data:', error);
        });
}

function displayLoans(loans) {
    const loansContainer = document.getElementById('loanDataContainer');
    loansContainer.innerHTML = '';

    const table = document.createElement('table');
    table.classList.add('loan-table');

    const thead = table.createTHead();
    const headerRow = thead.insertRow();
    const headers = ['Loan ID', 'User ID', 'User Name', 'Book ID', 'Book Title', 'Loan Date', 'Expected Return Date', 'Return Date', 'Return Status', 'Extend Status', 'Reserved', 'Actions'];
    headers.forEach(headerText => {
        const headerCell = document.createElement('th');
        headerCell.textContent = headerText;
        headerRow.appendChild(headerCell);
    });

    const tbody = table.createTBody();
    loans.forEach(loan => {
        const row = tbody.insertRow();
        row.insertCell().textContent = loan.loan_id;
        row.insertCell().textContent = loan.user ? loan.user.id : '-';
        row.insertCell().textContent = loan.user ? loan.user.name : '-';
        row.insertCell().textContent = loan.book ? loan.book.id : '-';
        row.insertCell().textContent = loan.book ? loan.book.title : '-';
        row.insertCell().textContent = formatDate(loan.loan_date);
        row.insertCell().textContent = formatDate(loan.expect_date);
        row.insertCell().textContent = formatDate(loan.return_date);
        row.insertCell().textContent = loan.return_status ? 'Returned' : 'Not Returned';
        row.insertCell().textContent = loan.extend_status ? 'Extended' : 'Not Extended';
        row.insertCell().textContent = loan.book.reserved ? 'Reserved' : 'Not Reserved';


        // 반납 상태에 따라 반납 버튼 추가
       const returnCell = row.insertCell();
		if (!loan.return_status) {
    	const returnButton = document.createElement('button');
    	returnButton.textContent = '반납';
    	returnButton.onclick = function() { returnLoan(loan.loan_id); };
    	returnButton.style.fontSize = '15px';
		returnButton.style.padding = '10px 10px';
		returnButton.style.backgroundColor = 'red';
		returnButton.style.color = 'white';
		returnButton.style.border = 'none';    	
		returnCell.appendChild(returnButton);
    	
}
    });

    loansContainer.appendChild(table);
}

function returnLoan(loanId) {
    // 반납 처리 로직을 여기에 추가합니다.
    console.log(`Returning loan with ID: ${loanId}`);
    // TODO: 서버에 반납 요청을 보내는 로직을 구현합니다.
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString();
}


function fetchUserData() {
    console.log("fetchUserData called");
    fetch('/admin/users/all')
        .then(response => response.json())
        .then(users => {
            console.log("Users received:", users);
            populateUserSelect(users);
        })
        .catch(error => console.error('Error fetching users:', error));
}



function fetchBookData() {
    fetch('/admin/books/titles')
        .then(response => response.json())
        .then(books => populateBookSelect(books, 'bookIdSelect'))
        .catch(error => console.error('Error fetching book titles:', error));
}


function populateUserSelect(users) {
    const select = document.getElementById('userIdSelect');
    users.forEach(user => {
        const option = document.createElement('option');
        option.value = user.id; // 서버 응답에 맞춰 필드명 변경
		option.textContent = `${user.id} - ${user.name}`;
        select.appendChild(option);
    });
}


function populateBookSelect(books, selectId) {
    const select = document.getElementById(selectId);
    select.innerHTML = ''; // 기존의 옵션들을 초기화합니다.
    books.forEach(book => {
        const option = document.createElement('option');
        option.value = book.id; // 'id' 필드를 사용합니다.
        option.textContent = `${book.id} - ${book.title}`; // 'id'와 'title' 필드를 사용합니다.
        select.appendChild(option);
    });
}

function initiateLoan() {
    const userId = document.getElementById('userIdSelect').value;
    const bookId = document.getElementById('bookIdSelect').value;

    fetch('/admin/loan/create', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `user_id=${userId}&book_id=${bookId}`
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok: ' + response.statusText);
        }
        return response.text();
    })
    .then(data => {
        // 여기에서 대출 성공 메시지를 표시합니다.
        alert('대출이 완료되었습니다.'); // 사용자에게 알림
        window.location.reload(); // 페이지 새로고침
    })
    .catch(error => {
        console.error('Error creating loan:', error);
        alert('대출 생성 중 오류가 발생했습니다.'); // 사용자에게 오류 알림
    });
}

function returnLoan(loanId) {
    fetch(`/admin/loan/return/${loanId}`, {
        method: 'PUT',
        // ... 필요한 헤더 설정 ...
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok: ' + response.statusText);
        }
        return response.text();
    })
    .then(message => {
        alert(message); // 서버로부터 받은 메시지를 팝업 창으로 표시
        window.location.reload(); // 페이지를 새로고침하여 반납 처리된 상태를 반영합니다.
    })
    .catch(error => {
        console.error('Error returning the loan:', error);
        alert('반납 처리 중 오류가 발생했습니다.');
    });
}


