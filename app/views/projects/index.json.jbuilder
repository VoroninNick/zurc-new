json.array!(@projects) do |project|
  json.extract! project, :id, :name, :slug, :deadline_date
  json.url project_url(project, format: :json)
end
