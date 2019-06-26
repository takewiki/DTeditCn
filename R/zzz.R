
#' 设置DT为中文
#'
#' @return 返回值
#' @export
#'
#' @examples setDTtoCn();
setDTtoCn <- function(){
  options(DT.options = list(
    searchHighlight = TRUE,
    language = list(
      info = '显示第_START_ 至 _END_ 项结果，共 _TOTAL_ 项',
      search = '搜索:',
      paginate = list(previous = '上页', `next` = '下页'),
      lengthMenu = '显示 _MENU_ 项结果')))

}
