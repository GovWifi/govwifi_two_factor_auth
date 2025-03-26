require "active_record"

module GovwifiTwoFactorAuth
  module Orm
    module ActiveRecord
      module Schema
        include GovwifiTwoFactorAuth::Schema
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::Table.send :include, GovwifiTwoFactorAuth::Orm::ActiveRecord::Schema
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, GovwifiTwoFactorAuth::Orm::ActiveRecord::Schema
