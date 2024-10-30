// A generated module for Ckretz functions
//
// This module has been generated via dagger init and serves as a reference to
// basic module structure as you get started with Dagger.
//
// Two functions have been pre-created. You can modify, delete, or add to them,
// as needed. They demonstrate usage of arguments and return types using simple
// echo and grep commands. The functions can be called from the dagger CLI or
// from one of the SDKs.
//
// The first line in this comment block is a short description line and the
// rest is a long description with more detail on the module's purpose or usage,
// if appropriate. All modules should have a short description.

package main

import (
	"context"
	"dagger/ckretz/internal/dagger"
	"fmt"
	"math"
	"math/rand"
)

type Ckretz struct{}

// Publish the application container after building and testing it on-the-fly
func (m *Ckretz) Publish(ctx context.Context, source *dagger.Directory) (string, error) {
	_, err := m.Test(ctx, source)
	if err != nil {
		return "", err
	}
	return m.Build(ctx, source).
		Publish(ctx, fmt.Sprintf("ttl.sh/ckretz-app-arm-dagger-%.0f", math.Floor(rand.Float64()*10000000)))
}

// Build the application container
func (m *Ckretz) Build(ctx context.Context, source *dagger.Directory) *dagger.Container {
	return dag.Container().
		WithDirectory("/rails", source).
		WithWorkdir("/rails").
		Directory("/rails").
		DockerBuild()
	//return m.BuildEnv(source)
}

func (m *Ckretz) Postgres(ctx context.Context) *dagger.Container {
	return dag.Container().
		From("ankane/pgvector").
		WithEnvVariable("POSTGRES_USER", "postgres").
		WithEnvVariable("POSTGRES_PASSWORD", "password").
		WithExposedPort(5432)
}

func (m *Ckretz) PostgresService(ctx context.Context) *dagger.Service {
	return m.Postgres(ctx).AsService()
}

// Return the result of running unit tests
func (m *Ckretz) Test(ctx context.Context, source *dagger.Directory) (string, error) {
	return m.BuildEnv(source).
		WithServiceBinding("db", m.PostgresService(ctx)). // bind database with the name db
		WithEnvVariable("DB_HOST", "db").                 // db refers to the service binding
		WithEnvVariable("DATABASE_PRIMARY_RW_URL", "postgresql://db:5432/").
		WithEnvVariable("DATABASE_CACHE_RW_URL", "postgresql://db:5432/").
		WithEnvVariable("DATABASE_QUEUE_RW_URL", "postgresql://db:5432/").
		WithEnvVariable("DATABASE_CABLE_RW_URL", "postgresql://db:5432/").
		WithEnvVariable("ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY", "deterministickeyaaaaaaaaaaaaaaaa").
		WithEnvVariable("ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT", "keyderivationsaltbbbbbbbbbbbbbbb").
		WithEnvVariable("ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY", "primarykeycccccccddddddddddddddd").
		WithEnvVariable("COVERAGE", "0").
		WithEnvVariable("RAILS_ENV", "test").
		WithEnvVariable("DB_PASSWORD", "password"). // password set in db container
		WithEnvVariable("DB_USERNAME", "postgres"). // default user in postgres image
		WithEnvVariable("DB_NAME", "postgres").     // default db name in postgres image
		WithExec([]string{"bundle", "exec", "rake", "db:setup"}).
		WithExec([]string{"bundle", "exec", "rspec"}).
		WithExec([]string{"bundle", "exec", "rubocop"}).
		WithExec([]string{"bundle", "exec", "bundle-audit"}).
		WithExec([]string{"bundle", "exec", "brakeman"}).
		Stdout(ctx)
}

// Build a ready-to-use development environment
func (m *Ckretz) BuildEnv(source *dagger.Directory) *dagger.Container {
	rubyCache := dag.CacheVolume("rails-ckretz")
	return dag.Container().
		WithDirectory("/rails", source).
		WithMountedCache("/usr/local/bundle", rubyCache).
		WithWorkdir("/rails").
		Directory("/rails").
		DockerBuild().
		WithExec([]string{"bundle", "install"})
}

// Returns a container that echoes whatever string argument is provided
func (m *Ckretz) ContainerEcho(stringArg string) *dagger.Container {
	return dag.Container().From("alpine:latest").WithExec([]string{"echo", stringArg})
}

// Returns lines that match a pattern in the files of the provided Directory
func (m *Ckretz) GrepDir(ctx context.Context, directoryArg *dagger.Directory, pattern string) (string, error) {
	return dag.Container().
		From("alpine:latest").
		WithMountedDirectory("/mnt", directoryArg).
		WithWorkdir("/mnt").
		WithExec([]string{"grep", "-R", pattern, "."}).
		Stdout(ctx)
}
