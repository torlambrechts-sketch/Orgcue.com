// Refreshes the Supabase session on every request and keeps signed-out visitors on the public pages.
import { NextResponse, type NextRequest } from 'next/server';
import { createServerClient } from '@supabase/ssr';
import { AUTH_PAGES, MARKETING_PAGES, isPublic, safeNext } from '@/lib/auth-paths';

export async function middleware(request: NextRequest) {
  if (MARKETING_PAGES.includes(request.nextUrl.pathname)) return NextResponse.next();
  let response = NextResponse.next({ request });
  const supabase = createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL || '', process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '', {
    cookies: {
      getAll: () => request.cookies.getAll(),
      setAll: (list) => {
        list.forEach(({ name, value }) => request.cookies.set(name, value));
        response = NextResponse.next({ request });
        list.forEach(({ name, value, options }) => response.cookies.set(name, value, options));
      },
    },
  });
  // getUser() validates the token with Supabase Auth; do not trust the cookie alone.
  const { data: { user } } = await supabase.auth.getUser();
  const { pathname, search } = request.nextUrl;

  const redirect = (to: string) => {
    const r = NextResponse.redirect(new URL(to, request.url));
    response.cookies.getAll().forEach((c) => r.cookies.set(c));
    return r;
  };
  if (!user && !isPublic(pathname)) {
    const next = pathname + search;
    return redirect('/login?next=' + encodeURIComponent(next));
  }
  if (user && AUTH_PAGES.includes(pathname)) return redirect(safeNext(request.nextUrl.searchParams.get('next')));
  return response;
}

export const config = {
  // Not for static files or the files search engines and browsers fetch on their own (robots, sitemap, icons, social cards).
  matcher: ['/((?!_next/static|_next/image|favicon.ico|robots.txt|sitemap.xml|manifest.webmanifest|icon|apple-icon|opengraph-image|twitter-image|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico|woff2?|txt|xml)$).*)'],
};
