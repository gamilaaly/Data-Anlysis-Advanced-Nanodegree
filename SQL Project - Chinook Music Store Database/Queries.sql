-- Top 10 sold albums in the store
SELECT Album.Title,
       count(InvoiceLine.TrackId) PurchasesCount
FROM Album
JOIN Track ON Track.AlbumId = Album.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Album.Title
ORDER BY count(InvoiceLine.TrackId) DESC
LIMIT 10;

-- Most Popular Music Genre Per Countre
WITH PurchasesCountTable
AS (SELECT
  Country,
  Genre.Name AS Genre,
  COUNT(InvoiceLine.InvoiceId) AS PurchasesCount
FROM Invoice
JOIN InvoiceLine
  ON Invoice.InvoiceId = InvoiceLine.InvoiceId
JOIN Customer
  ON Invoice.CustomerId = Customer.CustomerId
JOIN Track
  ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre
  ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name,
         Country
ORDER BY 1, 3 DESC)

SELECT
  PurchasesCountTable.Country,
  PurchasesCountTable.Genre,
  PurchasesCountTable.PurchasesCount MaxPurchcasesCount
FROM PurchasesCountTable
JOIN (SELECT
  MAX(PurchasesCount) AS MaxPurchases,
  Country,
  Genre
FROM PurchasesCountTable
GROUP BY Country) MaxPurchase
  ON PurchasesCountTable.Country = MaxPurchase.Country
WHERE PurchasesCountTable.PurchasesCount = MaxPurchase.MaxPurchases
ORDER BY 3 DESC;

-- Number of Invoices Per Country
SELECT
  Country,
  COUNT(Invoice.InvoiceId) AS Invoices
FROM Customer
JOIN Invoice
  ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Country
ORDER BY 2 DESC;

-- Agents with most Sales
SELECT Employee.FirstName || ' ' || Employee.LastName AgentName,
       Count(Invoice.InvoiceId) InvoicesCount
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Employee.FirstName,
         Employee.LastName
ORDER BY Count(Invoice.InvoiceId) DESC;

