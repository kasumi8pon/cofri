# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags
    {
      site: "coFri",
      reverse: "true",
      charset: "utf-8",
      description: "複数人が料理をする家庭向けの、 冷蔵庫の中身を管理できるアプリです。",
      og: {
        title: :title,
        type: "website",
        site_name: "coFri",
        description: :description,
        image: "https://cofri.herokuapp.com/ogp/ogp.png",
        url: "https://cofri.herokuapp.com",
      },
      twitter: {
        card: "summary",
        site: "@kasumi8pon"
      }
    }
  end
end
