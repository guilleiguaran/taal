Sequel.migration do
  change do
    create_table(:builds) do
      primary_key :id
      String :url
      String :script
      String :status, default: 'pending'
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
