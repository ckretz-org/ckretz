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
	"fmt"
	"math"
	"math/rand"
	"dagger/ckretz/internal/dagger"
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

// Return the result of running unit tests
func (m *Ckretz) Test(ctx context.Context, source *dagger.Directory) (string, error) {
	return m.BuildEnv(source).
		WithExec([]string{"bundle", "exec", "bin/rubocop"}).
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
