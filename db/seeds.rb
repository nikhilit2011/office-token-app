User.find_or_create_by!(email: "operator@example.com") do |user|
  user.password = "password"
  user.role = "token_operator"
end

User.find_or_create_by!(email: "incharge@example.com") do |user|
  user.password = "password"
  user.role = "counter_incharge"
  user.assigned_counter = "Green Card"
end

User.find_or_create_by!(email: "admin@example.com") do |u|
  u.password = "password"
  u.role = "admin"
end