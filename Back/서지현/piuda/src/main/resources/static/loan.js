window.onload = function() {
    fetchLoanData();
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

function displayLoans(loans) {
    const loansContainer = document.getElementById('loanDataContainer');
    loansContainer.innerHTML = '';

    const table = document.createElement('table');
    table.classList.add('loan-table');

    const thead = table.createTHead();
    const headerRow = thead.insertRow();
    const headers = ['Loan ID', 'User ID','User Name', 'Book ID', 'Book Title', 'Loan Date', 'Expected Return Date', 'Return Date', 'Return Status', 'Extend Status'];
    headers.forEach(headerText => {
        const headerCell = document.createElement('th');
        headerCell.textContent = headerText;
        headerRow.appendChild(headerCell);
    });

    const tbody = table.createTBody();
    loans.forEach(loan => {
        const row = tbody.insertRow();
        row.insertCell().textContent = loan.loan_id;
        row.insertCell().textContent = loan.user ? loan.user.id : 'N/A';
        row.insertCell().textContent = loan.user ? loan.user.name : 'N/A';
        row.insertCell().textContent = loan.book ? loan.book.id : 'N/A';
        row.insertCell().textContent = loan.book ? loan.book.title : 'N/A';
        row.insertCell().textContent = formatDate(loan.loan_date);
        row.insertCell().textContent = formatDate(loan.expect_date);
        row.insertCell().textContent = formatDate(loan.return_date);
        row.insertCell().textContent = loan.return_status ? 'Returned' : 'Not Returned';
        row.insertCell().textContent = loan.extend_status ? 'Extended' : 'Not Extended';
    });

    loansContainer.appendChild(table);
}

function formatDate(dateString) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString();
}
