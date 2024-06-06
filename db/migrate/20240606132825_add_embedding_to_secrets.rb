class AddEmbeddingToSecrets < ActiveRecord::Migration[7.1]
  def change
    add_column :secrets, :embedding, :vector, limit: 768
    add_index :secrets, :embedding, using: :hnsw, opclass: :vector_l2_ops
  end
end
