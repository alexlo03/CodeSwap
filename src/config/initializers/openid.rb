Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'LSND7ekG525w7OIsLYaPSQ', 'plZaDzNATAFfZlfyhyU3c5XBn3dtUZFV3vRQmmUKc'
  provider :google, '227068049875.apps.googleusercontent.com', 'NIj3MuESOhlVKND79W5xOPvs'
end
