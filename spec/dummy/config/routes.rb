Rails.application.routes.draw do
  mount_ember_app(
    "my-app",
    to: "/no-block",
    controller: "high_voltage/pages",
    action: "show",
    id: "include_index",
    as: "include_index",
  )

  mount_ember_app(
    "my-app",
    to: "/empty-block",
    controller: "high_voltage/pages",
    action: "show",
    id: "include_index_empty_block",
    as: "include_index_empty_block",
  )

  mount_ember_app(
    "my-app",
    to: "/head-and-body-block",
    controller: "high_voltage/pages",
    action: "show",
    id: "include_index_head_and_body",
    as: "include_index_head_and_body",
  )

  mount_ember_app(
    "my-app",
    to: "/asset-helpers",
    controller: "high_voltage/pages",
    action: "show",
    id: "embedded",
    as: "embedded",
  )

  mount_ember_app(
    "my-app",
    to: "/",
    as: "default",
  )
end
