library(default)
default_font = 'sans'

default_font_size <- 10
default_line_size <- 1/.pt/3.82*4
default_font_size_mm <- default_font_size/ggplot2:::.pt

default_point_size <- 4*default_line_size

update_geom_defaults("line", list(linewidth = default_line_size))
update_geom_defaults("text", list(size = default_font_size_mm, family = default_font))
update_geom_defaults("segment", list(linewidth = default_line_size))
update_geom_defaults("pointrange", list(linewidth = default_line_size))
update_geom_defaults("vline", list(linewidth = default_line_size, color = '#AFABAB'))
update_geom_defaults("hline", list(linewidth = default_line_size, color = '#AFABAB'))
update_geom_defaults('function', list(linewidth = default_line_size))
# default(plot.pointrange) <- list(pointsize = default_point_size, linesize = default_line_size )


default_theme<-theme_light(base_size = default_font_size, base_line_size = default_line_size, base_family = default_font)+theme(
  axis.line=element_line(linewidth = I(0.5)), 
  axis.ticks= element_line(linewidth = I(0.25), colour = 'gray'),
  axis.line.x=element_line(),
  axis.line.y=element_line(),
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(),
  legend.title=element_text(size=rel(1)), 
  strip.text=element_text(size=rel(1), color = 'black'), 
  axis.text=element_text(size=rel(0.9), color = '#4e4e4e'), 
  axis.title=element_text(size=rel(1), color = '#4e4e4e'), 
  panel.border= element_blank(),
  strip.background = element_blank(),
  legend.position	='right', 
  plot.title=element_text(size=default_font_size, hjust = 0.5),
  plot.tag.position = c(0, 1),
  plot.background = element_blank(),
  text=element_text(size=default_font_size), 
  legend.text=element_text(size=rel(1)), 
  axis.line.x.bottom = element_blank(), 
  axis.line.y.left = element_blank(),
  axis.line.x.top = element_blank(),
  axis.line.y.right = element_blank())
theme_set(default_theme)

default_colors <-c('#3498db','#009f06','#f72034','#FF7F00', '#7A378B')
scale_colour_discrete <- function(...) scale_color_manual(values=default_colors, ...)
scale_fill_discrete <- function(...) scale_fill_manual(values=default_colors, ...)
scale_shape_discrete <- function(...) scale_shape_ac(...)
