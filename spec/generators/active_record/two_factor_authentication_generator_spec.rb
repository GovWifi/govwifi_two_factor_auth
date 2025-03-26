# frozen_string_literal: true

require "generators/active_record/two_factor_authentication_generator"

describe ActiveRecord::Generators::TwoFactorAuthenticationGenerator, type: :generator do
  destination File.expand_path("../../dummy/tmp", File.dirname(__FILE__))

  before do
    prepare_destination
  end

  it "runs all methods in the generator" do
    gen = generator %w[users]
    expect(gen).to receive(:copy_two_factor_authentication_migration)
    gen.invoke_all
  end

  describe "the generated files" do
    before do
      run_generator %w[users]
    end

    describe "the migration" do
      let(:migration_content) {}

      it "contains a migration" do
        migration =  File.open(Dir["spec/dummy/tmp/db/migrate/*_two_factor_authentication_add_to_users.rb"].first,
                               "r").read
        expect(migration).to include "def change"
        expect(migration).to include "add_column :users, :second_factor_attempts_count, :integer, default: 0"
        expect(migration).to include "add_column :users, :encrypted_otp_secret_key, :string"
        expect(migration).to include "add_column :users, :encrypted_otp_secret_key_iv, :string"
        expect(migration).to include "add_column :users, :encrypted_otp_secret_key_salt, :string"
        expect(migration).to include "add_index :users, :encrypted_otp_secret_key, unique: true"
      end
    end
  end
end
