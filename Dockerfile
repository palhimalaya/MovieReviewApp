# Use an official Ruby runtime as a parent image
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION

# Set the working directory
# WORKDIR /app

# Install dependencies
# Install libvips for Active Storage preview support
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

# Install gems
COPY Gemfile Gemfile.lock ./
RUN  bundle install

# Copy the application code
COPY . .


# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompilessss

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]



# Expose ports
EXPOSE 3000

# Set the entrypoint command
CMD ["rails", "server", "-b", "0.0.0.0"]