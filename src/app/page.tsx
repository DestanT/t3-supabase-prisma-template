import { DeployButton } from "@/components/deploy-button";
import { AuthButton } from "@/components/auth-button";
import { Hero } from "@/components/hero";
import { ThemeSwitcher } from "@/components/theme-switcher";
import { LatestPost } from "@/app/_components/post";
import { api, HydrateClient } from "@/trpc/server";
import Link from "next/link";

export default async function Home() {
  const hello = await api.post.hello({ text: "from tRPC" });

  void api.post.getLatest.prefetch();

  return (
    <HydrateClient>
      <main className="flex min-h-screen flex-col items-center">
        <div className="flex w-full flex-1 flex-col items-center gap-20">
          <nav className="border-b-foreground/10 flex h-16 w-full justify-center border-b">
            <div className="flex w-full max-w-5xl items-center justify-between p-3 px-5 text-sm">
              <div className="flex items-center gap-5 font-semibold">
                <Link href={"/"}>Next.js Supabase Starter</Link>
                <div className="flex items-center gap-2">
                  <DeployButton />
                </div>
              </div>
              <AuthButton />
            </div>
          </nav>
          <div className="flex max-w-5xl flex-1 flex-col gap-20 p-5">
            <Hero />
            <div className="flex flex-col items-center gap-2">
              <p className="text-2xl text-white">
                {hello ? hello.greeting : "Loading tRPC query..."}
              </p>
            </div>
            <LatestPost />
          </div>

          <footer className="mx-auto flex w-full items-center justify-center gap-8 border-t py-16 text-center text-xs">
            <p>
              Powered by{" "}
              <a
                href="https://supabase.com/?utm_source=create-next-app&utm_medium=template&utm_term=nextjs"
                target="_blank"
                className="font-bold hover:underline"
                rel="noreferrer"
              >
                Supabase
              </a>
            </p>
            <ThemeSwitcher />
          </footer>
        </div>
      </main>
    </HydrateClient>
  );
}
