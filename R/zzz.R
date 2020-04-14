
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
      lengthMenu = '显示 _MENU_ 项结果',
      infoFiltered='(从 _MAX_ 记录过滤结果)',
      loadingRecords='数据加载中...',
      processing='处理中,请稍候...',
      infoEmpty='没有找到匹配记录',
      emptyTable='没有可显示数据',
      zeroRecords='没有找到匹配记录'
    )
  ))

}
