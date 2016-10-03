## @knitr workflowBreakdown

library(DiagrammeR)

workflowBreakdown <- grViz("
digraph workflowbreakdown {

        # graph, node, and edge definitions
        graph [layout = dot,
        fontname = Helvetica]
        
        node [shape = box,
        fontname = Helvetica,
        style = filled]
        
        # node definitions with substituted label text
        a [label = 'String manipulation\nand data reduction', fillcolor = tomato]
        b [label = 'Calculating the distance', fillcolor = deepskyblue]
        c [label = 'Mapping the groupings', fillcolor = violet]
        
        # Ranking
        {rank = same; a; b; c;}
        
        # edge definitions with the node IDs
        a -> b -> c
        }
        ")
workflowBreakdown

## @knitr workflowSolution
workflowSolution <- grViz("
digraph workflowsolution {

      # graph, node, and edge definitions
      graph [layout = dot]

      node [shape = box,
            fontname = Helvetica,
            style = filled]
      
      # node definitions with substituted label text
      a [label = 'String manipulation\nand data reduction', fillcolor = tomato]
      b [label = 'Calculating the distance', fillcolor = deepskyblue]
      c [label = 'Mapping the groupings', fillcolor = violet]
      dt [label = 'data.table', fillcolor = wheat]
      stringr [label = 'stringr', fillcolor = palegoldenrod]
      geos [label = 'geosphere', fillcolor = lemonchiffon]
      ggm [label = 'ggmap', fillcolor = khaki]
      word [label = 'word()', fillcolor = palegoldenrod, color = tomato]
      subs [label = 'substr()', fillcolor = oldlace, color = tomato]
      NOT [label = '!', fillcolor = wheat, color = tomato]
      IN [label = '%in%', fillcolor = wheat, color = tomato]
      SD [label = '.SD', fillcolor = wheat, color = tomato]
      dist [label = 'distm()', fillcolor = lemonchiffon, color = deepskyblue]
      I [label = '.I', fillcolor = wheat, color = deepskyblue]
      getm [label = 'get_map()', fillcolor = khaki, color = violet]
      ggmp [label = 'ggmap()', fillcolor = khaki, color = violet]
      chull [label = 'chull()', fillcolor = oldlace, color = violet]
      on [label = 'on=', fillcolor = wheat, color = deepskyblue]
      melt [label = 'melt()', fillcolor = wheat, color = deepskyblue]
      assi [label = ':=', fillcolor = wheat, color = tomato]
      
      # Ranking
      {rank = source; a; b; c;}
      {rank = same; dt; stringr; geos; ggm}
      {rank = sink; subs; chull; on; melt; assi; word; NOT; IN; SD; dist; I; getm; ggmp}
      
      # edge definitions with the node IDs
      a -> b -> c
      a -> {dt stringr subs} [style=invis];
      b -> {dt geos} [style=invis];
      c -> {dt ggm} [style=invis];
      dt -> {NOT IN SD I} [style=invis]
      stringr-> word [style=invis]
      geos -> dist [style=invis]
      ggm -> {getm ggmp} [style=invis]
      a -> {word subs NOT IN assi SD} [arrowhead = none, color = tomato]
      b -> {dist melt I on} [arrowhead = none, color = deepskyblue]
      c -> {getm ggmp chull} [arrowhead = none, color = violet]
      word -> subs -> assi -> NOT -> IN ->  SD -> dist -> melt -> I -> on -> getm -> ggmp -> chull
      
}
      ")
workflowSolution
