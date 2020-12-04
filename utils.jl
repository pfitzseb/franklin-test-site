function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

@delay function hfun_navigation()
  all_pages = sort!(collect(keys(Franklin.ALL_PAGE_VARS)))

  nav = []
  for page in all_pages
    parts = split(page, '/')

    this_page_vars = Franklin.ALL_PAGE_VARS[page]

    title = first(get(this_page_vars, "title", "" => nothing))
    hidden = first(get(this_page_vars, "hidden", false => nothing))
    order = first(get(this_page_vars, "order", 999 => nothing))
    icon = first(get(this_page_vars, "icon", "" => nothing))

    if !isempty(title) && !hidden
      route = ""
      if length(parts) == 1
        route = string('/', page === "index" ? "" : page)
      elseif length(parts) == 2 && parts[end] == "index"
        route = string('/', parts[1])
      else
        continue
      end
      push!(nav, (
        title = title,
        order = order,
        route = route,
        icon = icon
      ))
    end
  end
  sort!(nav, by = x -> x.order)
  output = IOBuffer()

  for item in nav
    @show item
    pretty_url = match(r"(.*)/index.html", first(Franklin.LOCAL_VARS["fd_url"]))
    is_active = pretty_url !== nothing && pretty_url[1] == item.route || (pretty_url[1] == "" && item.route == "/")
    println(output,
    """
      <li><a href="$(item.route)" class="$(is_active ? "active" : "")">$(item.title)</a></li>
    """)
  end

  return String(take!(output))
end