library(shiny)
library(RSQLite)
library(DTeditCn)
options(DT.options = list(
  searchHighlight = TRUE,
  language = list(
    info = '显示第_START_ 至 _END_ 项结果，共 _TOTAL_ 项',
    search = '搜索:',
    paginate = list(previous = '上页', `next` = '下页'),
    lengthMenu = '显示 _MENU_ 项结果')))

##### Load books data.frame as a SQLite database
conn <- dbConnect(RSQLite::SQLite(), "books.sqlite")

# if(!'books' %in% dbListTables(conn)) {
# 	books <- read.csv('books.csv', stringsAsFactors = FALSE)
# 	books$Authors <- strsplit(books$Authors, ';')
# 	books$Authors <- lapply(books$Authors, trimws) # Strip white space
# 	books$Authors <- unlist(lapply(books$Authors, paste0, collapse = ';'))
# 	books$id <- 1:nrow(books)
# 	books$Date <- paste0(books$Date, '-01-01')
# 	dbWriteTable(conn, "books", books, overwrite = TRUE)
# }

getBooks <- function() {
	res <- dbSendQuery(conn, "SELECT * FROM books")
	books <- dbFetch(res)
	dbClearResult(res)
	books$Authors <- strsplit(books$Authors, ';')
	books$Date <- as.Date(books$Date)
	books$Publisher <- as.factor(books$Publisher)
	return(books)
}

##### Callback functions.
books.insert.callback <- function(data, row) {
	query <- paste0("INSERT INTO books (id, Authors, Date, Title, Publisher) VALUES (",
					"", max(getBooks()$id) + 1, ", ",
					"'", paste0(data[row,]$Authors[[1]], collapse = ';'), "', ",
					"'", as.character(data[row,]$Date), "', ",
					"'", data[row,]$Title, "', ",
					"'", as.character(data[row,]$Publisher), "' ",
					")")
	print(query) # For debugging
	dbSendQuery(conn, query)
	return(getBooks())
}

books.update.callback <- function(data, olddata, row) {
	query <- paste0("UPDATE books SET ",
					"Authors = '", paste0(data[row,]$Authors[[1]], collapse = ';'), "', ",
					"Date = '", as.character(data[row,]$Date), "', ",
					"Title = '", data[row,]$Title, "', ",
					"Publisher = '", as.character(data[row,]$Publisher), "' ",
					"WHERE id = ", data[row,]$id)
	print(query) # For debugging
	dbSendQuery(conn, query)
	return(getBooks())
}

books.delete.callback <- function(data, row) {
	query <- paste0('DELETE FROM books WHERE id = ', data[row,]$id)
	dbSendQuery(conn, query)
	return(getBooks())
}

##### Create the Shiny server
server <- function(input, output) {
	books <- getBooks()
	dteditCn(input, output,
		   name = 'books',
		   thedata = books,
		   edit.cols = c('Title', 'Authors', 'Date', 'Publisher'),
		   edit.label.cols = c('Book Title1', 'Authors2', 'Publication Date3', 'Publisher4'),
		   input.types = c(Title='textAreaInput'),
		   input.choices = list(Authors = unique(unlist(books$Authors))),
		   view.cols = names(books)[1:3],
		   label.add = '新增',
		   label.copy = '复制',
		   label.edit = '修改',
		   label.delete = '删除',
		   title.add = '新增界面',
		   title.edit = '修改界面',
		   title.delete = '删除界面',
		   show.copy = FALSE,
		   defaultPageLength = 15,
		   callback.update = books.update.callback,
		   callback.insert = books.insert.callback,
		   callback.delete = books.delete.callback)


}

##### Create the shiny UI
ui <- fluidPage(
	h3('Books'),
	uiOutput('books')
)

shinyApp(ui = ui, server = server)
