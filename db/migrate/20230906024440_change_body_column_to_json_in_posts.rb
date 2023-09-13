class ChangeBodyColumnToJsonInPosts < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' if !extension_enabled?('pgcrypto')
    change_column :posts, :body, :jsonb, using: 'body::jsonb' # Change "body" to JSONB
  end
end
