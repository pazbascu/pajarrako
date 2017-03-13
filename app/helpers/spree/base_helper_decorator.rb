module Spree::BaseHelper

def layout_partial
  if devise_controller?
    'spree/base/devise'
  else
    'spree/base/application'
  end
end

def taxon_breadcrumbs(taxon, separator = "&nbsp;&raquo;&nbsp;", breadcrumb_class = "inline")
      return "" if current_page?("/") || taxon.nil?

      crumbs = [[Spree.t(:home), spree.root_path]]

      if taxon
        crumbs << [Spree.t(:products), products_path]
        crumbs += taxon.ancestors.collect { |a| [a.name, spree.nested_taxons_path(a.permalink)] } unless taxon.ancestors.empty?
        crumbs << [taxon.name, spree.nested_taxons_path(taxon.permalink)]
      else
        crumbs << [Spree.t(:products), products_path]
      end

      separator = raw(separator)

      crumbs.map! do |crumb|
        content_tag(:li, itemscope: "itemscope", itemtype: "http://data-vocabulary.org/Breadcrumb") do
          link_to(crumb.last, itemprop: "url") do
            content_tag(:span, crumb.first, itemprop: "title")
          end + (crumb == crumbs.last ? '' : separator)
        end
      end

      content_tag(:nav, content_tag(:ul, raw(crumbs.map(&:mb_chars).join), class: breadcrumb_class), id: 'breadcrumbs', class: 'sixteen columns')
end

 def nav_tree(root_taxon, current_taxon, max_level = 1)
      return '' if max_level < 1 || root_taxon.children.empty?
      content_tag :ul, class: 'dropdown-menu' do
        taxons = root_taxon.children.map do |taxon|
          css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'active' : nil
          content_tag :li, class: css_class do
           link_to(taxon.name, seo_url(taxon)) +
             taxons_tree(taxon, current_taxon, max_level - 1)
          end
        end
        safe_join(taxons, "\n")
      end
    end

def flash_messages(opts = {})
    ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

    flash.each do |msg_type, text|
      unless ignore_types.include?(msg_type)
        concat(content_tag :div, text, class: "flash alert alert-#{msg_type}")
      end
    end
    nil
end

end
